//
//  DetailMovieViewModel.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//
import UIKit

enum DetailMovieViewModelState {
    case loading
    case loaded(String)
}

final class DetailMovieViewModel {

    var onStateDidChange: ((DetailMovieViewModelState) -> Void)?

    private(set) var state: DetailMovieViewModelState = .loading {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.onStateDidChange?(self.state)
            }
        }
    }

    func loadDetail() {
        state = .loading
        state = .loaded("Test Detail")
    }
}
