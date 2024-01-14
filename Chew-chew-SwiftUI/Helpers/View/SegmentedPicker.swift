//
//  SegmentedPicker.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.11.23.
//

import Foundation
import SwiftUI

public struct SegmentedPicker<T: Equatable, Content: View>: View {
	
	// Tells SwiftUI which views can be animated together
	@Namespace private var selectionAnimation
	@Binding var selectedItem: T
	private let items: [T]
	private let content: (T) -> Content
	let externalAction : (T) -> Void

	public init(
		_ items: [T],
		selectedItem: Binding<T>,
		@ViewBuilder content: @escaping (T) -> Content,
		externalAction : @escaping (T) -> Void
	) {
		self._selectedItem = selectedItem
		self.items = items
		self.content = content
		self.externalAction = externalAction
	}
	
	
	// @ViewBuilder is a great way to conditionally show Views
	//   but makes the highlight overlay into "different" Views to the View Layout System
	
	@ViewBuilder func overlay(for item: T) -> some View {
		if item == selectedItem {
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.chewFillAccent)
			// This is the magic for the animation effect when the selection changes
				.matchedGeometryEffect(id: "selectedSegmentHighlight", in: self.selectionAnimation)
		}
	}

	public var body: some View {
		HStack {
			ForEach(self.items.indices, id: \.self) { index in
				Button(
					action: {
						self.selectedItem = self.items[index]
						externalAction(self.selectedItem)
					},
					label: {
						self.content(self.items[index])
							.font(.system(
								size: 15,
								weight: self.items[index] == self.selectedItem ? .semibold : .regular)
							)
							.foregroundColor(.primary)
					}
				)
				.background(self.overlay(for: self.items[index]))
			}
		}
		.animation(.spring(), value: self.selectedItem)
	}
}
