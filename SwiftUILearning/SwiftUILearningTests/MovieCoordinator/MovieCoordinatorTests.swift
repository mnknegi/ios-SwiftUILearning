//
//  MovieCoordinatorTests.swift
//  SwiftUILearningTests
//
//  Created by Mayank Negi on 08/02/25.
//

import XCTest
@testable import SwiftUILearning

final class MovieCoordinatorTests: XCTestCase {

    func testFetchMovie() {
        let mockResponseGenerator = MockMovieListResponseGenerator()
        let mockService = MockServicePeroviding(
            responseType: .movieList(shouldFail: false),
            movieListResponse: mockResponseGenerator.getResponse(of: MovieResponse.self, for: .movieList)
        )
        let serviceCoordinator = MovieCoordinator(service: mockService)
        let expectation = XCTestExpectation(description: "This should succeed")
        let urlRequest = URLRequest(url: URL(string: "https:\\test.com")!)
        serviceCoordinator.fetchMovies(with: urlRequest) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("There should be no failure raised here")
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    func testFetchMovieFaul() {
        let mockResponseGenerator = MockMovieListResponseGenerator()
        let mockService = MockServicePeroviding(
            responseType: .movieList(shouldFail: true),
            movieListResponse: mockResponseGenerator.getResponse(of: MovieResponse.self, for: .movieList)
        )
        let serviceCoordinator = MovieCoordinator(service: mockService)
        let expectation = XCTestExpectation(description: "This should succeed")
        let urlRequest = URLRequest(url: URL(string: "https:\\test.com")!)
        serviceCoordinator.fetchMovies(with: urlRequest) { result in
            switch result {
            case .success:
                XCTFail("This should have failed but have succeeded")
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
