//
//  MovieResponse.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

struct SearchResponse: Decodable {
    let search: [Movie]?
    let totalResults: String?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }

    var isSuccess: Bool {
        response.lowercased() == "true"
    }

    var moviesUnwrapped: [Movie] {
        search ?? []
    }
}
