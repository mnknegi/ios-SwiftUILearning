//
//  MovieCoordinator.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import Foundation

protocol MovieCoordinating {
    func fetchMovies(with request: URLRequest, completion: @escaping (Result<[Movie], NetworkError>) -> Void)
}

final class MovieCoordinator: MovieCoordinating {

    let service: ServiceProviding

    init(service: ServiceProviding = Service()) {
        self.service = service
    }

    func fetchMovies(with request: URLRequest, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        self.service.perform(request) { (response: Result<MovieResponse, NetworkError>) in
            switch response {
            case .success(let result):
                let movies = result.search
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
