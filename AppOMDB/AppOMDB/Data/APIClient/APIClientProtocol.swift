//
//  APIClientProtocol.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, APIError>) -> Void)
}
