//
//  MockServicePerforming.swift
//  SwiftUILearningTests
//
//  Created by Mayank Negi on 08/02/25.
//

import Foundation
@testable import SwiftUILearning

final class MockServicePeroviding: ServiceProviding {

    private let responseType: MockResponseType
    private let movieListResponse: MovieResponse?

    init(responseType: MockResponseType, movieListResponse: MovieResponse?) {
        self.responseType = responseType
        self.movieListResponse = movieListResponse
    }

    func perform<T>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {

        switch responseType {
        case .movieList(let shouldFail):
            if shouldFail {
                completion(.failure(NetworkError.unknown))
            } else {
                completion(.success(movieListResponse as! T))
            }
        }
    }
}

enum MockResponseType {
    case movieList(shouldFail: Bool)
}
