//
//  MovieCoordinator.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import Foundation
import Combine

protocol MovieCoordinating {
    func fetchMovies(with request: URLRequest, completion: @escaping (Result<[Movie], NetworkError>) -> Void)
    func fetchMoviesUsingCombine(with request: URLRequest, viewModel: MovieListViewModel)
}

final class MovieCoordinator: @preconcurrency MovieCoordinating {

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

    @MainActor func fetchMoviesUsingCombine(with request: URLRequest, viewModel: MovieListViewModel) {
        self.service.performUsingCombine(request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Combine function error in Coordinator: \(error).")
                case .finished:
                    print("fetch finished using combine.")
                }
            } receiveValue: { (response: MovieResponse) in
                viewModel.update(response.search)
            }.store(in: &viewModel.cancellable)
    }
}
