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
		return Button(
			action: {
				type.sendEvent(send: chewViewModel.send)
			}, label: {
				switch type {
				case .departure:
					switch status {
					case .loadingLocation:
						ProgressView()
					default:
						switch searchStopViewModel.state.status {
						case .loading,.updatingRecentStops:
							if type == searchStopViewModel.state.type {
								ProgressView()
							} else {
								type.baseImage
							}
						case .idle,.loaded,.error:
							type.baseImage
						}
					}
				case .arrival:
					type.baseImage
				}
			}
		)
		.frame(width: 20)
		.padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 12))
		.foregroundColor(.primary)
	}
}
