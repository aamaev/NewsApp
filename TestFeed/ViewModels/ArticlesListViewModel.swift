//
//  ArticlesListViewModel.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import Foundation
import Combine

class ArticlesListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var blocks: [NavigationBlock] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var route: BlockRoute?
    
    private var page = 1
    private let pageSize = 10
    private var totalPages: Int?
    
    private var cancellables = Set<AnyCancellable>()
    private var inFlightRequest: AnyCancellable?
    
    func loadInitialIfNeeded() {
        guard articles.isEmpty else { return }
        loadInitial()
    }
    
    func loadInitial() {
        startInitialLoad(reset: true)
    }

    func refresh() {
        startInitialLoad(reset: false)
    }
    
    private func startInitialLoad(reset: Bool) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            page = 1
            totalPages = nil
            articles.removeAll()
            blocks.removeAll()
        }

        inFlightRequest?.cancel()

        let articlesPub = APIService.shared
            .fetchArticles(page: 1, pageSize: pageSize)

        let blocksPub = APIService.shared
            .fetchNavigationBlocks()

        inFlightRequest = Publishers.Zip(articlesPub, blocksPub)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.handleError(err)
                }
            } receiveValue: { [weak self] (resp, navBlocks) in
                guard let self = self else { return }
                self.articles = resp.results
                self.totalPages = resp.pages
                self.blocks = navBlocks
                self.page = 1
            }

        if let c = inFlightRequest {
            c.store(in: &cancellables)
        }
    }
    
    func loadMoreIfNeeded(current item: Article?) {
        guard !isLoading else { return }
        guard let item = item, let last = articles.last, item.id == last.id else { return }
        if let total = totalPages, page >= total { return }
        
        isLoading = true
        
        let nextPage = page + 1
        
        APIService.shared.fetchArticles(page: nextPage, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.handleError(err)
                }
            } receiveValue: { [weak self] resp in
                guard let self = self else { return }
                self.articles.append(contentsOf: resp.results)
                self.totalPages = resp.pages
                self.page = nextPage
            }
            .store(in: &cancellables)
    }
    
    func filteredArticles(for tab: NewsTab, using store: NewsStore) -> [Article] {
        switch tab {
        case .all:
            return articles.filter { !store.isBlocked($0.id) }
        case .favorites:
            return articles.filter { store.isFavorite($0.id) && !store.isBlocked($0.id) }
        case .blocked:
            return articles.filter { store.isBlocked($0.id) }
        }
    }
    
    func blockAfterArticle(at index: Int) -> NavigationBlock? {
        guard !blocks.isEmpty else { return nil }
        
        let position = index + 1
        guard position.isMultiple(of: 2) else { return nil }

        let zeroBased = position / 2 - 1
        return zeroBased < blocks.count ? blocks[zeroBased] : nil
    }
    
    private func handleError(_ err: APIError) {
        if case .network(let code) = err, code == .notConnectedToInternet {
            alertTitle = "No Internet Connection"
        } else {
            alertTitle = "Something Went Wrong"
        }
        showAlert = true
    }
}
