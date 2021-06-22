//
//  NotionPagesView.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/17.
//

import SwiftUI
import Combine
import notion

struct NotionPagesView: View {
    struct URLContainer: Identifiable {
        let id = UUID()
        let url: URL
    }

    @ObservedObject var viewModel: ViewModel = .init()
    @State var url: URLContainer?

    var body: some View {
        NavigationView {
            List(viewModel.topPages, children: \.children) { page in
                Image(systemName: "add")
                Text(page.base.retrieveTitle()!)
            }
        }
        .sheet(item: $url, content: { url in
            NotionWebViewPage(url: url.url)
        })
        .alert(isPresented: .init(get: { viewModel.error != nil }, set: { _ in viewModel.error = nil })) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: Alert.Button.cancel()
            )
        }.onAppear {
            viewModel.fetchPages()
        }
    }
}

extension NotionPagesView {
    final class ViewModel: ObservableObject {
        @Environment(\.notion) private var session
        @Published var topPages: [Page] = []
        @Published var error: Swift.Error?
        var cancellables: [AnyCancellable] = []
        
        class Page: Identifiable {
            var id: String { base.id }
            let base: Object.Page
            var children: [Page]?
            init(base: Object.Page) {
                self.base = base
            }
        }
        
        func fetchPages() {
            session.send(V1.Search.Search(query: "")).sink { [weak self] result in
                switch result {
                case let .success(response):
                    let notionPages: [Object.Page] = response.results.compactMap {
                        if case let .page(page) = $0.object {
                            return page
                        } else {
                            print("[INFO]", $0.object)
                            return nil
                        }
                    }

                    let pages: [Page] = notionPages.map(Page.init(base:))
                    for page in pages {
                        for child in pages {
                            if case let .pageId(parentID) = child.base.parent.type {
                                if page.id == parentID {
                                    if page.children == nil {
                                        page.children = []
                                    }
                                    page.children?.append(child)
                                }
                            }
                        }
                    }
                    let topPages = pages.filter { page in
                        switch page.base.parent.type {
                        case .databaseId, .workspace:
                            return true
                        case .pageId:
                            return false
                        }
                    }
                    self?.topPages = topPages
                case let .failure(error):
                    self?.error = error
                }
            }.store(in: &cancellables)
        }

    }
}

struct NotionPagesView_Previews: PreviewProvider {
    static var previews: some View {
        NotionPagesView()
    }
}
