//
//  ContentStateView.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import UIKit

enum ContentStateViewState {
    case loading
    case empty(message: String)
    case error(message: String)
    case hidden
}

final class ContentStateView: UIView {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.hidesWhenStopped = true
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 17)
        l.textColor = .secondaryLabel
        return l
    }()

    var state: ContentStateViewState = .hidden {
        didSet { updateContent() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(messageLabel)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
        updateContent()
    }

    private func updateContent() {
        switch state {
        case .loading:
            isHidden = false
            activityIndicator.startAnimating()
            messageLabel.text = nil
            messageLabel.isHidden = true
        case .empty(let message), .error(let message):
            isHidden = false
            activityIndicator.stopAnimating()
            messageLabel.text = message
            messageLabel.isHidden = false
        case .hidden:
            isHidden = true
            activityIndicator.stopAnimating()
            messageLabel.text = nil
            messageLabel.isHidden = true
        }
    }
}
