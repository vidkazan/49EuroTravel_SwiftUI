//
//  SearchStopsView+RightButton.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

extension SearchStopsView {
	func rightButton(type : LocationDirectionType) -> some View {
		let image : Image = {
			switch type {
			case .departure:
				return Image(systemName: "location")
			case .arrival:
				return Image(systemName: "arrow.up.arrow.down")
			}
		}()
		return Button(
			action: {
				switch type {
				case .departure:
					chewViewModel.send(event: .didLocationButtonPressed)
					break
				case .arrival:
					chewViewModel.send(event: .onStopsSwitch)
				}
			}, label: {
				switch searchStopViewModel.state.status {
				case .loading:
					if type == searchStopViewModel.state.type {
						ProgressView()
					} else {
						image
					}
				case .idle,.loaded,.error:
					image
				}
			})
			.frame(width: 20)
			.padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 12))
			.foregroundColor(.primary)
	}
}
