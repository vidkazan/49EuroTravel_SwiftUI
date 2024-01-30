//
//  FlowLayout.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.01.24.
//

import Foundation
import SwiftUI

extension Sequence where Element == CGRect {
	var union: CGRect {
		reduce(.null, { $0.union($1) })
	}
}

func layout(sizes: [CGSize], containerWidth: CGFloat,spacing: CGSize) -> [CGRect] {
	var result: [CGRect] = []
	var currentPosition: CGPoint = .zero
	
	func startNewline() {
		if currentPosition.x == 0 { return }
		currentPosition.x = 0
		currentPosition.y = result.union.maxY + spacing.height
	}
	
	for size in sizes {
		if currentPosition.x + size.width > containerWidth {
			startNewline()
		}
		result.append(CGRect(origin: currentPosition, size: size))
		currentPosition.x += size.width + spacing.width
	}
	return result
}

@available(iOS 16.0, *)
struct FlowLayout: Layout {
	let spacing : CGSize
	init(spacing: CGSize = .init(width: 10, height: 10)) {
		self.spacing = spacing
	}
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let containerWidth = proposal.replacingUnspecifiedDimensions().width
		let sizes = subviews.map {
			$0.sizeThatFits(.unspecified)
		}
		return layout(sizes: sizes, containerWidth: containerWidth,spacing: spacing).union.size
	}
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let subviewSizes = subviews.map {
			$0.sizeThatFits(.unspecified)
		}
		let frames = layout(sizes: subviewSizes, containerWidth: bounds.width, spacing: spacing)
		for (f, subview) in zip(frames, subviews) {
			let offset = CGPoint(x: f.origin.x + bounds.minX, y: f.origin.y + bounds.minY)
			subview.place(at: offset, proposal: .unspecified)
		}
	}
}
