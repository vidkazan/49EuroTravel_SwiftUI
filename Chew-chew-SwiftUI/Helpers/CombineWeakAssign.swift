//
//  CombineWeakAssign.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.01.24.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
	func weakAssign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on root: Root) -> AnyCancellable {
	   sink { [weak root] in
			root?[keyPath: keyPath] = $0
	   }
	}
}
