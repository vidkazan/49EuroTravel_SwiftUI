//
//  NetworkMonitor.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.01.24.
//

import Foundation
import Network

class NetworkMonitor {
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "Monitor")
	private weak var alertVM : AlertViewModel?

	init(alertVM:  AlertViewModel?) {
		self.alertVM = alertVM
		networkMonitor.pathUpdateHandler = { path in
			switch path.status {
			case .requiresConnection:
				alertVM?.send(event: .didRequestShow)
			case .satisfied:
				alertVM?.send(event: .didTapDismiss)
			case .unsatisfied:
				alertVM?.send(event: .didRequestShow)
			@unknown default:
				fatalError("\(Self.self): unknown networkMonitor status")
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}

