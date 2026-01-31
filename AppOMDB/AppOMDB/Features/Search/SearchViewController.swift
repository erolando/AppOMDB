//
//  SearchViewController.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import UIKit

final class SearchViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Buscar películas..."
        bar.searchBarStyle = .minimal
        return bar
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 110
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private let contentStateView: ContentStateView = {
        let v = ContentStateView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = SearchViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OMDB Movies"
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupTableView()
        view.addSubview(contentStateView)
        NSLayoutConstraint.activate([
            contentStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            contentStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        viewModel.onStateDidChange = { [weak self] state in
            self?.updateUI(state: state)
        }
        updateUI(state: viewModel.state)
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        searchBar.delegate = self
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }

    private func updateUI(state: SearchState) {
        switch state {
        case .idle:
            tableView.isHidden = false
            tableView.reloadData()
        case .loading:
            contentStateView.state = .loading
            tableView.isHidden = false
            tableView.reloadData()
        case .results:
            contentStateView.state = .hidden
            tableView.isHidden = false
            tableView.reloadData()
        case .empty:
            contentStateView.state = .empty(message: "No se encontraron películas. Prueba otro término.")
            tableView.isHidden = false
            tableView.reloadData()
        case .error(let text):
            contentStateView.state = .error(message: text)
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movies[indexPath.row]
        let detailVC = DetailMovieViewController(imdbID: movie.imdbID)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(query: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.scheduleSearch(query: searchText)
    }
}
