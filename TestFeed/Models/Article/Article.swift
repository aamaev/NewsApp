//
//  Article.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import Foundation

struct Article: Codable, Identifiable, Hashable {
    let id: String
    let type: String
    let sectionId: String
    let sectionName: String
    let webPublicationDate: String
    let webTitle: String
    let webUrl: String
    let apiUrl: String
    let isHosted: Bool
    let pillarId: String
    let pillarName: String
    
    var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return isoFormatter.date(from: webPublicationDate)
            .map { dateFormatter.string(from: $0) } ?? ""
    }
}
