//
//  APIClient.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(String)
    case networkFailure(Error)
    case httpError(statusCode: Int)
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid search query"
        case .noData:
            return "No results found"
        case .decodingError(let message):
            return "Unable to process results: \(message)"
        case .serverError(let message):
            return message
        case .networkFailure:
            return "Network connection failed"
        case .httpError(let statusCode):
            return "Network Error statusCode: \(statusCode)"
        }
    }
}

final class APIClient: APIClientProtocol {
    
    // MARK: - Properties
    private let session: URLSession

    // MARK: - Initialization
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkFailure(NSError(domain: "Invalid Response", code: 0))))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
#if DEBUG
            self?.logResponse(data: data, url: url)
#endif
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
#if DEBUG
                print("❌ Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    self?.printDecodingError(decodingError)
                }
#endif
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    
#if DEBUG
    /// Log API response for debugging
    private func logResponse(data: Data, url: URL) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📡 API Response from: \(url.absoluteString)")
            print("📄 JSON: \(jsonString)")
        }
    }
    
    /// Print detailed decoding error information
    private func printDecodingError(_ error: DecodingError) {
        switch error {
        case .keyNotFound(let key, let context):
            print("❌ Key '\(key.stringValue)' not found: \(context.debugDescription)")
            print("   Coding path: \(context.codingPath)")
        case .typeMismatch(let type, let context):
            print("❌ Type mismatch for type \(type): \(context.debugDescription)")
            print("   Coding path: \(context.codingPath)")
        case .valueNotFound(let type, let context):
            print("❌ Value not found for type \(type): \(context.debugDescription)")
            print("   Coding path: \(context.codingPath)")
        case .dataCorrupted(let context):
            print("❌ Data corrupted: \(context.debugDescription)")
            print("   Coding path: \(context.codingPath)")
        @unknown default:
            print("❌ Unknown decoding error: \(error)")
        }
    }
#endif
}
