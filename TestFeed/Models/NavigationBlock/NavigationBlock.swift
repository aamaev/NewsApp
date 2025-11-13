//
//  NavigationBlock.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import Foundation

struct NavigationBlock: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let buttonTitle: String
    let buttonSymbol: String?
    let titleSymbol: String?
    let navigation: String
    
    var kind: NavigationKind {
        NavigationKind(rawValue: navigation) ?? .push
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, navigation
        case buttonTitle = "button_title"
        case buttonSymbol = "button_symbol"
        case titleSymbol  = "title_symbol"
    }
    
    enum NavigationKind: String {
        case push
        case modal
        case full_screen
    }
}
