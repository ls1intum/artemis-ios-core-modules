//
//  ArtemisWebView.swift
//  
//
//  Created by Sven Andabaka on 23.03.23.
//

import SwiftUI
import WebKit

public struct ArtemisWebView: UIViewRepresentable {

    @Binding var urlRequest: URLRequest
    @Binding var contentHeight: CGFloat
    @Binding var isLoading: Bool

    private let isScrollEnabled: Bool

    public init(urlRequest: Binding<URLRequest>, contentHeight: Binding<CGFloat>, isLoading: Binding<Bool>) {
        self._urlRequest = urlRequest
        self._contentHeight = contentHeight
        self._isLoading = isLoading
        isScrollEnabled = false
    }

    public init(urlRequest: Binding<URLRequest>, isLoading: Binding<Bool>) {
        self._urlRequest = urlRequest
        self._contentHeight = .constant(.s)
        self._isLoading = isLoading
        isScrollEnabled = true
    }

    public func makeUIView(context: Context) -> WKWebView {
        // configure click event listener
        let config = WKWebViewConfiguration()
        let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage(''); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(context.coordinator, name: "iosListener")

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
        Coordinator(contentHeight: $contentHeight, isLoading: $isLoading)
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        @Binding var contentHeight: CGFloat
        @Binding var isLoading: Bool

        var webView: WKWebView?

        /// Used for checking the loading progress
        private var timer: Timer?

        init(contentHeight: Binding<CGFloat>, isLoading: Binding<Bool>) {
            self._contentHeight = contentHeight
            self._isLoading = isLoading
        }

        deinit {
            timer?.invalidate()
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // check if the document is really loaded
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
                if self?.isLoading == true {
                    self?.updateLoadingStateIfDocumentIsReady(webView)
                } else {
                    timer.invalidate()
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
                self?.determineHeight(for: webView)
            }
        }

        /// Determines the height for the web view by taking several samples over time
        /// - Parameters:
        ///   - webView: a WKWebView loading some page
        ///   - maxSampleCount: the number of samples that should be taken. This is needed because the content height might increase as the page loads more content and
        ///    we don't have a reliable way of checking when this loading process is really finished
        ///   - sampleInterval: the time interval between samples
        private func determineHeight(for webView: WKWebView, maxSampleCount: Int = 5, sampleInterval: TimeInterval = 1.0) {
            timer?.invalidate() // because timer will be reused

            var currentSampleNumber = 0

            // reuse the timer to set the height
            timer = Timer.scheduledTimer(withTimeInterval: sampleInterval, repeats: true) { [weak self] timer in
                if currentSampleNumber == maxSampleCount {
                    timer.invalidate()
                    return
                }
                self?.setParentHeight()
                currentSampleNumber += 1
            }
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.x > 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            }
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            setParentHeight()
            // and whatever other actions you want to take
        }

        private func setParentHeight() {
            webView?.evaluateJavaScript("document.body.scrollHeight") { [weak self] height, _ in
                guard let height = height as? CGFloat else { return }
                DispatchQueue.main.async {
                    self?.contentHeight = height
                }
            }
        }
    }
}

extension URLSession {
    var authenticationCookie: [HTTPCookie]? {
        let cookies = HTTPCookieStorage.shared.cookies
        return cookies
    }
}
