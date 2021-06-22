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
            List {
                ForEach(viewModel.topPages) { (page) in
                    Button(action: {
                        if let url = page.base.pageURL() {
                            self.url = .init(url: url)
                        }
                    }, label: {
                        Text(page.id)
                    })
                }
            }.listStyle(InsetGroupedListStyle())
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
        @Published var topPages: [TopPage] = []
        @Published var error: Swift.Error?
        var cancellables: [AnyCancellable] = []
        
        struct TopPage: Identifiable {
            var id: String { base.id }
            let base: Object.Page
            var children: [TopPage] = []
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

                    var topPages: [TopPage] = notionPages.filter { notionPage in
                        if case .databaseId = notionPage.parent.type {
                            return true
                        }
                        return false
                    }
                    .map(TopPage.init(base:))
                    for topPageIndex in topPages.indices {
                        for notionPage in notionPages {
                            if case let .pageId(notionPageID) = notionPage.parent.type {
                                var topPage = topPages[topPageIndex]
                                if topPage.id == notionPageID {
                                    topPage.children.append(TopPage(base: notionPage))
                                    topPages[topPageIndex] = topPage
                                }
                            }
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
