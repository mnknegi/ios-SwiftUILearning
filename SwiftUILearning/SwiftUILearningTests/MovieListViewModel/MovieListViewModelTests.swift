//
//  MovieListViewModelTests.swift
//  SwiftUILearningTests
//
//  Created by Mayank Negi on 10/02/25.
//

@testable import SwiftUILearning
import XCTest

final class MovieListViewModelTests: XCTestCase {

    private var viewModel: MovieListViewModel!

    @MainActor func testFetchMovieSuccessful() {
        let mockMovieCoordinator = MovieListViewModelTests.make(returnState: .success, response: .movieList)
        viewModel = MovieListViewModel(coordinator: mockMovieCoordinator)
        viewModel.fetchMovies(for: "Batman")
        XCTAssertFalse(viewModel.movies.isEmpty)
    }

    @MainActor func testFetchMovieFailure() {
        let mockMovieCoordinator = MovieListViewModelTests.make(returnState: .fail, response: nil)
        viewModel = MovieListViewModel(coordinator: mockMovieCoordinator)
        viewModel.fetchMovies(for: "Batman")
        XCTAssertTrue(viewModel.movies.isEmpty)
    }

    private static func make(returnState: MovieServiceReturnState, response: MovieServiceResponseType?) -> MovieCoordinating {
        let coordinator = MockMovieCoodinator(returnState: returnState, response: response)
        return coordinator
    }

}
