//
//  PrintThread.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.10.23.
//

import Foundation

extension Thread {
	class func printCurrent() {
		print("\r⚡️: \(Thread.current)\r")
	}
}
