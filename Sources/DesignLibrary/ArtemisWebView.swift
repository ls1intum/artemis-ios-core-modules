//
//  ArtemisWebView.swift
//
//
//  Created by Sven Andabaka on 23.03.23.
//

import SwiftUI
import WebKit
import Combine

public struct ArtemisWebView: UIViewRepresentable {

    @Binding var urlRequest: URLRequest
    @Binding var contentHeight: CGFloat
    @Binding var isLoading: Bool

    /// If set, this query string will be used to determine `contentHeight`. Otherwise, `document.body.scrollHeight` will be used.
    var customJSHeightQuery: String?

    private let isScrollEnabled: Bool
    private static let scriptMessageHandlerName = "iosListener"

    public init(urlRequest: Binding<URLRequest>, contentHeight: Binding<CGFloat>, isLoading: Binding<Bool>, customJSHeightQuery: String? = nil) {
        self._urlRequest = urlRequest
        self._contentHeight = contentHeight
        self._isLoading = isLoading
        self.customJSHeightQuery = customJSHeightQuery
        isScrollEnabled = false
    }

    public init(urlRequest: Binding<URLRequest>, isLoading: Binding<Bool>, customJSHeightQuery: String? = nil) {
        self._urlRequest = urlRequest
        self._contentHeight = .constant(.s)
        self._isLoading = isLoading
        self.customJSHeightQuery = customJSHeightQuery
        isScrollEnabled = true
    }

    public func makeUIView(context: Context) -> WKWebView {
        // configure click event listener
        let config = WKWebViewConfiguration()
        let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage(''); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(context.coordinator, name: Self.scriptMessageHandlerName)

        // set up WKWebView
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        webView.scrollView.isScrollEnabled = isScrollEnabled
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        if let cookie = URLSession.shared.authenticationCookie?.first {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        // TODO: this does not supress the warning
        DispatchQueue.main.async {
            if isLoading {
                webView.load(urlRequest)
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(contentHeight: $contentHeight, isLoading: $isLoading, customJSHeightQuery: customJSHeightQuery)
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        @Binding var contentHeight: CGFloat
        @Binding var isLoading: Bool

        var webView: WKWebView?
        var customJSHeightQuery: String?

        /// Used for checking the loading progress
        private var timer: Timer?
        private var currentHeightSampleNumber = 1
        private var sizeChangeCancellable: AnyCancellable?

        init(contentHeight: Binding<CGFloat>, isLoading: Binding<Bool>, customJSHeightQuery: String?) {
            self._contentHeight = contentHeight
            self._isLoading = isLoading
            self.customJSHeightQuery = customJSHeightQuery
        }

        deinit {
            timer?.invalidate()
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // check if the document is really loaded
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                if self?.isLoading == true {
                    self?.updateLoadingStateIfDocumentIsReady(webView)
                } else {
                    self?.determineHeight(for: webView)
                }
            }
        }

        private func updateLoadingStateIfDocumentIsReady(_ webView: WKWebView) {
            webView.evaluateJavaScript("document.readyState") { [weak self] complete, _ in
                guard complete != nil else { return }

                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                self?.webView = webView

                // reset the height if webView is resized
                self?.sizeChangeCancellable = webView
                    .publisher(for: \.scrollView.contentSize)
                    .removeDuplicates()
                    .sink { [weak self] _ in
                        self?.setParentHeight(withCustomJSQuery: self?.customJSHeightQuery)
                    }
            }
        }

        /// Determines the height for the web view by taking several samples over time
        /// - Parameters:
        ///   - webView: a WKWebView loading some page
        ///   - maxSampleCount: the number of samples that should be taken. This is needed because the content height might increase as the page loads more content and
        ///    we don't have a reliable way of checking when this loading process is really finished
        private func determineHeight(for webView: WKWebView, maxSampleCount: Int = 10) {
            if currentHeightSampleNumber == maxSampleCount {
                timer?.invalidate()
                return
            }

            self.setParentHeight(withCustomJSQuery: customJSHeightQuery)
            currentHeightSampleNumber += 1
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.x > 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            }
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            setParentHeight(withCustomJSQuery: customJSHeightQuery)
            // and whatever other actions you want to take
        }

        public func setParentHeight(withCustomJSQuery customQuery: String? = nil) {
            let query = customQuery ?? "document.body.scrollHeight"

            webView?.evaluateJavaScript(query) { [weak self] height, _ in
                guard let height = height as? CGFloat else { // query failed
                    if customQuery != nil { // it was a custom query
                        self?.setParentHeight(withCustomJSQuery: nil) // fallback to default (nil)
                    }
                    return
                }

                DispatchQueue.main.async {
                    self?.contentHeight = height
                }
            }
        }
    }

    public static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        ArtemisWebView.removeScriptMessageHandler(uiView)
    }

    /// Removes the WKScriptMessageHandler instance from WebView to prevent a retain cycle
    /// See this for more info: https://stackoverflow.com/a/32443423/7074664
    private static func removeScriptMessageHandler(_ webView: WKWebView) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: scriptMessageHandlerName)
    }
}

extension URLSession {
    var authenticationCookie: [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies
        return cookies
    }
}
