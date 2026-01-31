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
        setupTableView()
        
        viewModel.onStateDidChange = { [weak self] state in
            self?.updateUI(state: state)
        }
        updateUI(state: viewModel.state)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        let _ = viewModel.movies[indexPath.row]
        let detailVC = UIViewController() // FIXME: Pending
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
