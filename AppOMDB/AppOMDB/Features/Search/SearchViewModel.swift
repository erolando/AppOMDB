//
//  SearchViewModel.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//
import Foundation

enum SearchState {
    case idle
    case loading
    case results([Movie])
    case empty
    case error(String)
}

final class SearchViewModel {
    
    let movieRepository: MoviesRepositoryProtocol
    
    init(movieRepository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.movieRepository = movieRepository
    }

    var onStateDidChange: ((SearchState) -> Void)?

    private(set) var state: SearchState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onStateDidChange?(self.state)
            }
        }
    }

    var movies: [Movie] {
        if case .results(let list) = state { return list }
        return []
    }

    func search(query: String) {
        let q = query.trimmingCharacters(in: .whitespaces)
        if q.isEmpty {
            state = .idle
            return
        }
        state = .loading
        movieRepository.searchMovies(query: q) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.state = list.isEmpty ? .empty : .results(list)
            case .failure(let err):
                self.state = .error(err.localizedDescription)
            }
        }
    }
}
