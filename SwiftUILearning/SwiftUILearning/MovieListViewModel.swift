//
//  MovieListViewModel.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import Foundation
import SwiftUI

// Alternative ways to prevent background UI refresh
@MainActor
final class MovieListViewModel: ObservableObject {

    @Published var movies: [MovieRowModel] = []

    private let coordinator: MovieCoordinating

    init(coordinator: MovieCoordinating = MovieCoordinator()) {
        self.coordinator = coordinator
    }

    // Difference between URL and URLRequest
    func fetchMovies(for title: String) {
        guard let url = URL(string:"https://www.omdbapi.com/?s=%5C\(title)&page=1&apikey=5c248545") else {
            return
        }

        let urlRequest = URLRequest(url: url)
        self.coordinator.fetchMovies(with: urlRequest) { result in
            switch result {
            case .success(let movies):
                self.movies = movies.map { MovieRowModel.init(movie: $0) }
            case .failure(let error):
                print("show alert Something went wrong. Please try again after some time.", error.localizedDescription)
            }
        }
    }
}

final class MovieRowModel {

    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var title: String {
        movie.title
    }

    var year: String {
        movie.year
    }

    var imdbID: String {
        movie.imdbID
    }

    var type: String {
        movie.type
    }

    var poster: URL? {
        URL(string: movie.poster)
    }
}
