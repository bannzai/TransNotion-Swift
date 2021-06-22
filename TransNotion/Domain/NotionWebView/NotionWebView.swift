//
//  NotionWebView.swift
//  TransNotion
//
//  Created by 廣瀬雄大 on 2021/06/22.
//

import SwiftUI
import UIKit
import WebKit

struct NotionWebView: UIViewRepresentable {
    @Binding var url: URL
    @Binding var isLoading: Bool

    @EnvironmentObject var state: TransNotionApp.State
    @ObservedObject var observer: Observer = .init()

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = context.coordinator

        observer.observations.append(
            webView.observe(\.isLoading, changeHandler: { webView, change in
                DispatchQueue.main.async {
                    isLoading = webView.isLoading
                    webView.isUserInteractionEnabled = !webView.isLoading
                }
            })
        )
        observer.observations.append(
            webView.observe(\.url, changeHandler: { webView, _ in
                DispatchQueue.main.async {
                    if let url = webView.url {
                        self.url = url
                    }
                }
            })
        )

        webView.load(URLRequest(url: url))

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }

    // MARK: - Coordinate
    final class Coordinator: NSObject {
        let webView: NotionWebView

        init(webView: NotionWebView) {
            self.webView = webView
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(webView: self)
    }
    
    // MARK: - Observer
    final class Observer: ObservableObject {
        fileprivate var observations: [NSKeyValueObservation] = []
    }
}

private let allowHosts: [String] = ["www.notion.so", "notion.so"]
extension NotionWebView.Coordinator: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let host = url.host, allowHosts.contains(host) else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
