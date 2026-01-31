//
//  AsyncImageView.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import UIKit

final class AsyncImageView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()

    private var dataTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    /// Modo de contenido de la imagen (p. ej. .scaleAspectFill para celdas, .scaleAspectFit para detalle).
    var imageContentMode: UIView.ContentMode {
        get { imageView.contentMode }
        set { imageView.contentMode = newValue }
    }

    /// Carga la imagen desde `urlString`. Si es nil, "N/A" o inválida, muestra placeholder.
    /// Cancela cualquier carga anterior.
    func loadImage(from urlString: String?) {
        dataTask?.cancel()
        dataTask = nil

        guard let urlString = urlString,
              urlString != "N/A",
              let url = URL(string: urlString) else {
            showPlaceholder()
            return
        }

        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let image = image {
                    self.imageView.image = image
                    self.imageView.tintColor = nil
                } else {
                    self.showPlaceholder()
                }
            }
        }
        dataTask?.resume()
    }

    private func showPlaceholder() {
        imageView.image = UIImage(systemName: "film.fill")
        imageView.tintColor = .systemGray3
    }
}
