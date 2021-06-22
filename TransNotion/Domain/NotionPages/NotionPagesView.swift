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
    @ObservedObject var viewModel: ViewModel = .init()
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pages) { (page) in
                    NavigationLink(destination: NotionPageView(viewModel: .init(id: page.id))) {
                        Text(page.retrieveTitle() ?? page.id)
                    }
                }
            }.listStyle(InsetGroupedListStyle())
        }
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
        @Published var pages: [Object.Page] = []
        @Published var error: Swift.Error?
        var cancellables: [AnyCancellable] = []
        
        func fetchPages() {
            session.send(V1.Search.Search(query: "")).sink { [weak self] result in
                switch result {
                case let .success(response):
                    self?.pages = response.results.compactMap {
                        if case let .page(page) = $0.object {
                            return page
                        } else {
                            return nil
                        }
                    }
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
