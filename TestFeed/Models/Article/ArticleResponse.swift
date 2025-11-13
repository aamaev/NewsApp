//
//  ArticleResponse.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import Foundation

struct ArticleResponse: Codable {
    let response: ResponseData
}

struct ResponseData: Codable {
    let status: String
    let startIndex: Int
    let pageSize: Int
    let currentPage: Int
    let pages: Int
    let results: [Article]
}
