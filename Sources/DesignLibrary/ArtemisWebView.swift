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
        let config = WKWebViewConfiguration()
        let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage('click clack!'); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(context.coordinator, name: "iosListener")
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

        init(contentHeight: Binding<CGFloat>, isLoading: Binding<Bool>) {
            self._contentHeight = contentHeight
            self._isLoading = isLoading
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                webView.evaluateJavaScript("document.readyState") { complete, _ in
                    guard complete != nil else { return }
                    self.isLoading = false
                    self.webView = webView
                    self.setParentHeight()
                }
            }
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.x > 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            }
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message: \(message.body)")
            setParentHeight()
            // and whatever other actions you want to take
        }

        private func setParentHeight() {
            webView?.evaluateJavaScript("document.body.scrollHeight") { height, _ in
                guard let height = height as? CGFloat else { return }
                self.contentHeight = height
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
