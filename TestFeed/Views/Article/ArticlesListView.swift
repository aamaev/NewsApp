//
//  ArticlesListView.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel: ArticlesListViewModel
    @ObservedObject var store: NewsStore
    
    let tab: NewsTab

    var body: some View {
        let filteredArticles = viewModel.filteredArticles(for: tab, using: store)

        ZStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(filteredArticles.enumerated()), id: \.element.id) { index, article in
                        ArticleRowView(
                            article: article,
                            tab: tab,
                            isFavorite: store.isFavorite(article.id),
                            isBlocked: store.isBlocked(article.id),
                            onFavorite: {
                                store.toggleFavorite(article.id)
                            },
                            onBlock: {
                                store.toggleBlocked(article.id)
                            }
                        )
                        .onAppear { viewModel.loadMoreIfNeeded(current: article) }

                        if tab == .all, let block = viewModel.blockAfterArticle(at: index) {
                            NavigationBlockView(navigationBlock: block) {
                                switch block.kind {
                                case .push:
                                    viewModel.route = .push(block)
                                case .modal:
                                    viewModel.route = .modal(block)
                                case .full_screen:
                                    viewModel.route = .fullScreen(block)
                                }
                            }
                        }
                    }
            
                    if viewModel.isLoading && !viewModel.articles.isEmpty {
                        ProgressView()
                            .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal)
            }

            errorStateView(filteredArticles: filteredArticles)
        }
        .refreshable { viewModel.refresh() }
        .task { viewModel.loadInitialIfNeeded() }
        .background(Color.backgroundLight.ignoresSafeArea())
        .presentBlockRoute($viewModel.route)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.showAlert = false
            }
        }
    }
    
    @ViewBuilder
    func errorStateView(filteredArticles: [Article]) -> some View {
        if viewModel.isLoading && viewModel.articles.isEmpty {
            ProgressView()
        } else if viewModel.articles.isEmpty {
            StatePlaceholderView(
                icon: "exclamationmark.triangle.fill",
                title: "No Result",
                buttonTitle: "Refresh",
                onButtonTap: { viewModel.loadInitial() }
            )
        } else if filteredArticles.isEmpty && !viewModel.isLoading {
            switch tab {
            case .all:
                StatePlaceholderView(
                    icon: "newspaper.fill",
                    title: "No Results",
                    buttonTitle: "Refresh",
                    onButtonTap: { viewModel.loadInitial() }
                )
            case .favorites:
                StatePlaceholderView(
                    icon: "heart",
                    title: "No Favorite News",
                )
            case .blocked:
                StatePlaceholderView(
                    icon: "nosign",
                    title: "No Blocked News",
                )
            }
        }
    }
}
