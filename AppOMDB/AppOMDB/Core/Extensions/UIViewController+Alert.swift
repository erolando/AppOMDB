//
//  UIViewController+Alert.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import UIKit

extension UIViewController {
    /// Muestra un alert con título "Error" y el mensaje indicado.
    /// - Parameters:
    ///   - message: Mensaje a mostrar.
    ///   - onDismiss: Closure opcional.
    func showError(_ message: String, onDismiss: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onDismiss?()
        })
        present(alert, animated: true)
    }
}
