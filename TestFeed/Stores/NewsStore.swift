//
//  NewsStore.swift
//  TestFeed
//
//  Created by Artem Amaev on 13.11.25.
//

import Foundation
import Combine

enum NewsKind: String, CaseIterable {
    case favorites
    case blocked
}

class NewsStore: ObservableObject {
    @Published private(set) var favorites: Set<String>
    @Published private(set) var blocked: Set<String>
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.favorites = Set(userDefaults.stringArray(forKey: NewsKind.favorites.rawValue) ?? [])
        self.blocked = Set(userDefaults.stringArray(forKey: NewsKind.blocked.rawValue) ?? [])
    }
    
    func isFavorite(_ id: String) -> Bool {
        favorites.contains(id)
    }
    
    func isBlocked(_ id: String) -> Bool {
        blocked.contains(id)
    }

    func toggleFavorite(_ id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        userDefaults.set(Array(favorites), forKey: NewsKind.favorites.rawValue)
        objectWillChange.send()
    }

    func toggleBlocked(_ id: String) {
        if blocked.contains(id) {
            blocked.remove(id)
        } else {
            blocked.insert(id)
        }
        userDefaults.set(Array(blocked), forKey: NewsKind.blocked.rawValue)
        objectWillChange.send()
    }
}
