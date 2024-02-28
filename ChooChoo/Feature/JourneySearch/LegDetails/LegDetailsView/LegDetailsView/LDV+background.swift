//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

extension LegDetailsView {
	var background : some View {
		ZStack(alignment: .top) {
			// MARK: BG - progress line
			VStack{
				HStack(alignment: .top) {
					Rectangle()
						.fill(Color.chewProgressLineGray)
						.frame(
							width: Self.progressLineBaseWidth,
							height: totalProgressHeight
						)
						.padding(.leading, 27)
					Spacer()
				}
				Spacer(minLength: 0)
			}
			VStack {
				HStack(alignment: .top) {
					RoundedRectangle(
						cornerRadius : totalProgressHeight == currentProgressHeight ? 0 : 6
					)
					.fill(Color.chewFillGreenPrimary)
					.frame(
						width: Self.progressLineBaseWidth + Self.progressLineCompletedBaseWidthOffset,
						height: currentProgressHeight
					)
						.padding(.leading,26)
					Spacer()
				}
				Spacer(minLength: 0)
			}
			.shadow(radius: 2)
			// MARK: BG - colors
			switch leg.legType {
			case .transfer,.footMiddle:
				EmptyView()
			case .footStart:
				Color.chewFillAccent.opacity(0.6)
					.frame(height: totalProgressHeight)
					.cornerRadius(10)
					.offset(y: -10)
			case .footEnd:
				Color.chewFillAccent.opacity(0.6)
					.frame(height: totalProgressHeight)
					.cornerRadius(10)
					.offset(y: 10)
			case .line:
				EmptyView()
			}
		}
		.frame(maxHeight: .infinity)
	}
}
