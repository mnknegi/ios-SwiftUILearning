//
//  Service.swift
//  SwiftUILearning
//
//  Created by Mayank Negi on 04/02/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case unknown
    case badRequest
    case badResponse
    case badDecoding
    case badData
}

protocol ServiceProviding {
    func perform<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
    func performUsingCombine<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

final class Service: ServiceProviding {

    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func perform<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.badRequest))
                print("ERROR while fetching: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.badResponse))
                return
            }

            guard let data else {
                completion(.failure(.badData))
                return
            }

            do{
                let decoder = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoder))
            } catch {
                completion(.failure(.badDecoding))
            }
        }

        task.resume()
    }

    func performUsingCombine<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        self.session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                if let error = error as? URLError {
                    return NetworkError.badResponse
                } else {
                    return NetworkError.badDecoding
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
