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
            VStack {
                List(viewModel.topPages, children: \.children) { page in
                    Button(action: { url = page.base.pageURL().map(URLContainer.init(url:)) }, label: {
                        Toggle(page.base.retrieveTitle()!, isOn: .init(get: { page.isChecked }, set: { viewModel.update(for: page, isChecked: $0) }))
                            .toggleStyle(CheckBoxToggleStyle())
                            .frame(height: 48)
                    })
                }
                .listStyle(PlainListStyle())
                Group {
                    let targetPages = viewModel.targetPages
                    Button(!targetPages.isEmpty ? "Translate \(targetPages.count) page" : "Check translate target pages") {
                        print("TODO: Translate and extract currnet page")
                    }
                    .disabled(targetPages.isEmpty)
                    .buttonStyle(PrimaryButtonStyle(width: .infinity))
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle(Text("Notion Pages"))
        }
        .accentColor(.appPrimary)
        .sheet(item: $url, content: { url in
            NotionWebViewPage(url: url.url)
        })
        .alert(isPresented: .init(get: { viewModel.error != nil }, set: { _ in viewModel.error = nil })) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? ""),
                dismissButton: Alert.Button.cancel()
            )
        }
        .onAppear {
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
        var allPages: [Page] = []
        var targetPages: [Page] {
            allPages.filter(\.isChecked)
        }

        class Page: Identifiable {
            var id: String { base.id }
            let base: Object.Page
            var children: [Page]?
            var isChecked: Bool = false
            init(base: Object.Page) {
                self.base = base
            }
        }
        
        func update(for page: Page, isChecked: Bool) {
            page.isChecked = isChecked
            // Call Published
            topPages = topPages
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

                    let allPages: [Page] = notionPages.map(Page.init(base:))
                    for page in allPages {
                        for child in allPages {
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
                    let topPages = allPages.filter { page in
                        switch page.base.parent.type {
                        case .databaseId, .workspace:
                            return true
                        case .pageId:
                            return false
                        }
                    }
                    self?.allPages = allPages
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
