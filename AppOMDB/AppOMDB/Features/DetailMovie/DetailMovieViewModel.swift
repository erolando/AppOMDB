//
//  DetailMovieViewModel.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//
import UIKit

enum DetailMovieViewModelState {
    case loading
    case loaded(MovieDetail)
    case error(String)
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

    let imdbID: String
    let movieRepository: MoviesRepositoryProtocol
    
    init(imdbID: String, movieRepository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.imdbID = imdbID
        self.movieRepository = movieRepository
    }

    /// Carga el detalle de la película.
    func loadDetail() {
        state = .loading
        movieRepository.fetchMovieDetail(imdbID: imdbID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detail):
                self.state = .loaded(detail)
            case .failure(let err):
                self.state = .error(err.localizedDescription)
            }
        }
    }
}
