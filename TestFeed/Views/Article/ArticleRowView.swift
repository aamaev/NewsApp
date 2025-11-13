//
//  ArticleRowView.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let tab: NewsTab
    var isFavorite: Bool = false
    var isBlocked: Bool = false
    var onFavorite: (() -> Void)? = nil
    var onBlock: (() -> Void)? = nil
    
    @Environment(\.openURL) private var openURL
    @State private var showBlockAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.backgroundLight)
                        .frame(width: 94, height: 86)

                    Image(systemName: "newspaper.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color.primaryBlue)
                        .padding(16)
                }
                    
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.webTitle)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.primaryDark)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(article.sectionName) • \(article.formattedDate)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.secondaryBlue)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Menu {
                        if tab != .blocked {
                            Button(action: { onFavorite?() }) {
                                Label(isFavorite ?
                                      "Remove from Favorites" : "Add to Favorites",
                                      systemImage: isFavorite ? "heart.slash" : "heart")
                            }
                        }
                        Button(role: .destructive) {
                            showBlockAlert = true
                        } label: {
                            Label(isBlocked ? "Unblock" : "Block",
                                  systemImage: isBlocked ? "lock.open.fill" : "nosign")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(Color.secondaryBlue)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    
                    Spacer(minLength: 0)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(Rectangle())
        .onTapGesture {
            if let url = URL(string: article.webUrl) {
                openURL(url)
            }
        }
        .alert(
            isPresented: $showBlockAlert,
            content: {
                Alert(
                    title: Text(isBlocked ?
                                "Do you want to unblock?" : "Do you want to block?"),
                    message: Text(isBlocked
                                  ? "Confirm to unblock this news source"
                                  : "Confirm to hide this news source"),
                    primaryButton: .destructive(Text(isBlocked ? "Unblock" : "Block").bold()) {
                        onBlock?()
                    },
                    secondaryButton: .cancel()
                )
            }
        )
    }
}
