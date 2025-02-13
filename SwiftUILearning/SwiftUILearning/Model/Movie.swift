//
//  Movie.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import Foundation

struct MovieResponse: Decodable {
    let search: [Movie]

    // tricky CodingKeys or CodingKey
    private enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    private enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
