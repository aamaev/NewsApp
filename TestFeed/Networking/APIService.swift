//
//  APIService.swift
//  TestFeed
//
//  Created by Artem Amaev on 12.11.25.
//

import Foundation
import Combine

enum APIConst {
    static let base = "https://us-central1-server-side-functions.cloudfunctions.net"
    static let token = "artem-amaev"
}

enum APIError: Error, LocalizedError {
    case badURL
    case badStatus(Int)
    case decoding(Error)
    case network(URLError.Code)

    var errorDescription: String? {
        switch self {
        case .badURL: 
            return "Bad URL"
        case .badStatus(let code):
            return "HTTP \(code)"
        case .decoding(let e):
            return "Decoding error: \(e.localizedDescription)"
        case .network(let code):
            return "Network error: \(code.rawValue)"
        }
    }
}

protocol APIServiceProtocol {
    func fetchArticles(page: Int, pageSize: Int) -> AnyPublisher<ResponseData, APIError>
    func fetchNavigationBlocks() -> AnyPublisher<[NavigationBlock], APIError>
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let decoder = JSONDecoder()
    
    private init() {}

    func fetchArticles(page: Int, pageSize: Int) -> AnyPublisher<ResponseData, APIError> {
        guard var urlComponents = URLComponents(string: APIConst.base + "/guardian") else {
            return Fail(error: .badURL).eraseToAnyPublisher()
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "page-size", value: String(pageSize))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: .badURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConst.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse,
                    200..<300 ~= http.statusCode else {
                    throw APIError.badStatus((output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: ArticleResponse.self, decoder: decoder)
            .map { $0.response }
            .mapError { error in
                if let urlErr = error as? URLError {
                    return .network(urlErr.code)
                }
                if let api = error as? APIError {
                    return api
                }
                if let dec = error as? DecodingError {
                    return .decoding(dec)
                }
                return .decoding(error)
            }
            .eraseToAnyPublisher()
    }

    func fetchNavigationBlocks() -> AnyPublisher<[NavigationBlock], APIError> {
        guard let url = URL(string: APIConst.base + "/navigation") else {
            return Fail(error: .badURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConst.token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse,
                    200..<300 ~= http.statusCode else {
                    throw APIError.badStatus((output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: NavigationBlockResponse.self, decoder: decoder)
            .map { $0.results }
            .mapError { error in
                if let urlErr = error as? URLError {
                    return .network(urlErr.code)
                }
                if let api = error as? APIError {
                    return api
                }
                if let dec = error as? DecodingError {
                    return .decoding(dec)
                }
                return .decoding(error)
            }
            .eraseToAnyPublisher()
    }
}
