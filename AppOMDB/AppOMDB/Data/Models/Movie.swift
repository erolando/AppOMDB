//
//  Movie.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

struct Movie: Decodable, Equatable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
