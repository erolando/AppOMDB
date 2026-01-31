//
//  SearchViewModel.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//
import Foundation

enum SearchState {
    case idle
}

final class SearchViewModel {

    var onStateDidChange: ((SearchState) -> Void)?

    private(set) var state: SearchState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onStateDidChange?(self.state)
            }
        }
    }

    var movies: [String] {
        return ["Test1","Test2","Test3","Test4"]
    }

    func search(query: String) {
    }
}
