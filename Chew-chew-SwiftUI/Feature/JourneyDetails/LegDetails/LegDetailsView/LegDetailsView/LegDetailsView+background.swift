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
						.frame(width: 20,height:  vm.state.data.totalProgressHeight)
						.padding(.leading,25)
					Spacer()
				}
				Spacer(minLength: 0)
			}
			VStack {
				HStack(alignment: .top) {
					RoundedRectangle(
						cornerRadius : vm.state.data.totalProgressHeight == currentProgressHeight ? 0 : 6
					)
					.fill(Color.chewFillGreenPrimary)
						.frame(width: 22,height: currentProgressHeight)
						.padding(.leading,24)
					Spacer()
				}
				Spacer(minLength: 0)
			}
			.shadow(radius: 2)
			// MARK: BG - colors
			switch vm.state.data.leg.legType {
			case .transfer,.footMiddle:
				VStack {
					Spacer()
					Color.chewFillAccent.opacity(0.6)
						.frame(height: vm.state.data.totalProgressHeight - 20)
						.cornerRadius(10)
					Spacer()
				}
			case .footStart:
				Color.chewFillAccent.opacity(0.6)
					.frame(height: vm.state.data.totalProgressHeight)
					.cornerRadius(10)
					.offset(y: -10)
			case .footEnd:
				Color.chewFillAccent.opacity(0.6)
					.frame(height: vm.state.data.totalProgressHeight)
					.cornerRadius(10)
					.offset(y: 10)
			case .line:
				EmptyView()
			}
		}
		.frame(maxHeight: .infinity)
	}
}
