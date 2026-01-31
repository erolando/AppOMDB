//
//  APIMoviesRepository.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}
    final class MoviesRepository: MoviesRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    private let baseURL: String
    private let apiKey: String
    
    // MARK: - Initialization
    init(
        apiClient: APIClientProtocol = APIClient(),
        baseURL: String = APIConfiguration.baseURL,
        apiKey: String = APIConfiguration.omdbAPIKey
    ) {
        self.apiClient = apiClient
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {

        guard var components = URLComponents(string: baseURL) else {
            print("Invalid URL")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: query)
        ]
        
        apiClient.request(components.url!) { (result: Result<SearchResponse, APIError>) in

            switch result {
            case .success(let response):
                completion(.success(response.search ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
