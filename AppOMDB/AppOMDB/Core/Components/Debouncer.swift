//
//  Debouncer.swift
//  AppOMDB
//
//  Created by Rolando Avila on 31/01/26.
//

import Foundation

final class Debouncer {
    private let interval: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    /// - Parameters:
    ///   - interval: Segundos de espera antes de ejecutar la acción.
    ///   - queue: Cola en la que se ejecuta la acción (por defecto main).
    init(interval: TimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }

    /// Programa la acción. Si ya había una programada, la cancela y programa esta.
    func schedule(action: @escaping () -> Void) {
        workItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        workItem = work
        queue.asyncAfter(deadline: .now() + interval, execute: work)
    }
}
