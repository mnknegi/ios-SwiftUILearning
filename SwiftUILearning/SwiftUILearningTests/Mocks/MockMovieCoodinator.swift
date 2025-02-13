//
//  MockMovieCoodinator.swift
//  SwiftUILearningTests
//
//  Created by Mayank Negi on 10/02/25.
//

@testable import SwiftUILearning
import Foundation

enum MovieServiceReturnState {
    case fail
    case success
}

final class MockMovieCoodinator: MovieCoordinating {

    private let returnState: MovieServiceReturnState
    var response: MovieServiceResponseType? = .movieList

    init(returnState: MovieServiceReturnState, response: MovieServiceResponseType?) {
        self.returnState = returnState
        self.response = response
    }

    func fetchMovies(with request: URLRequest, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        switch returnState {
        case .success:
            guard let response = MockMovieListResponseGenerator().getResponse(of: MovieResponse.self, for: response!) else {
                completion(.failure(.unknown))
                return
            }
            let movies = response.search
            completion(.success(movies))
        case .fail:
            completion(.failure(.badRequest))
        }
    }
}
