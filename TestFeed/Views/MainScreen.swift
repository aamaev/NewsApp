//
//  MainScreen.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import SwiftUI

enum NewsTab: String, CaseIterable {
    case all = "All"
    case favorites = "Favorites"
    case blocked = "Blocked"
}

struct MainScreen: View {
    @State private var selectedTab: NewsTab = .all
    @StateObject private var viewModel = ArticlesListViewModel()
    @StateObject private var store = NewsStore()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("News")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color.primaryDark)
                    
                    NewsSegmentedPicker(selection: $selectedTab)
                }
                .padding(.horizontal)

                Group {
                    switch selectedTab {
                    case .all:
                        ArticlesListView(viewModel: viewModel, store: store, tab: .all)
                    case .favorites:
                        ArticlesListView(viewModel: viewModel, store: store, tab: .favorites)
                    case .blocked:
                        ArticlesListView(viewModel: viewModel, store: store, tab: .blocked)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(Color.backgroundLight)
        }
    }
}

#Preview {
    MainScreen()
}
