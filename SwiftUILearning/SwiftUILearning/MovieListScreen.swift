//
//  MovieListScreen.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import SwiftUI

struct MovieListScreen: View {

    // StateObject cannot be let and should not be private.
    // Check the impact of private here.
    @StateObject private var viewModel = MovieListViewModel()
    @State private var searchQuery = ""

    var body: some View {
        NavigationStack {
            VStack {

                TextField("Enter search query", text: $searchQuery)
                    .onSubmit {
                        viewModel.fetchMovies(for: searchQuery)
                    }

                // `$` when to use it
                List(viewModel.movies, id: \.imdbID) { movie in
                    HStack {
                        AsyncImage(url: movie.poster) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if phase.error != nil {
                                Image(systemName: "person")
                                    .imageScale(.large)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 100)

                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.title)

                            Text(movie.year)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        } //: VSTACK

                    } //: HSTACK

                } //: LIST
                .listStyle(.plain)
                .scrollIndicators(.hidden)

            } //: VSTACK
            .onAppear {
                // will this hit the api everytime when code modified.
                viewModel.fetchMovies(for: "Batman")
            }
            .padding()
            .navigationTitle("Movies")
        }
    } //: NAVIGATION_STACK
}

#Preview {
    MovieListScreen()
}

// Difference between LazyVStack and list?
// what is the use of maxWidth and maxheight in frame - .infinite
