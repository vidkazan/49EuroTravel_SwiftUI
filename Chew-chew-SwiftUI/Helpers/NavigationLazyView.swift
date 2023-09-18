//
//  NavigationLazyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct NavigationLazyView<Content: View>: View {
	let build: () -> Content
	init(_ build: @autoclosure @escaping () -> Content) {
		self.build = build
	}
	var body: Content {
		build()
	}
}
