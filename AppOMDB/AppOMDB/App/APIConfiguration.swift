//
//  APIConfiguration.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//
import Foundation

struct APIConfiguration {
    static var omdbAPIKey: String {

        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OMDB_API_KEY") as? String,
           !apiKey.isEmpty {
            return apiKey
        }
        
        fatalError("Missing APIKey")
    }
    
    static var baseURL: String {
        return "https://www.omdbapi.com/" // NOTE: Move to xconfig
    }
}
