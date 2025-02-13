//
//  MockMovieListResponseGenerator.swift
//  SwiftUILearningTests
//
//  Created by Mayank Negi on 10/02/25.
//

import Foundation

final class MockMovieListResponseGenerator {

    func getResponse<T: Decodable>(of response: T.Type, for responseType: MovieServiceResponseType) -> T? {
        let testBundle = Bundle(for: MockMovieListResponseGenerator.self)
        guard let url = testBundle.url(forResource: responseType.rawValue, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                return nil
            }
            return response
        } catch {
            return nil
        }
    }
}

enum MovieServiceResponseType: String {
    case movieList = "movie-list"
}
