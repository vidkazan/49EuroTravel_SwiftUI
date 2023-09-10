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
					return
				case .arrival:
					searchJourneyViewModel.send(event: .onStopsSwitch)
					let tmp = searchJourneyViewModel.topSearchFieldText
					searchJourneyViewModel.topSearchFieldText = searchJourneyViewModel.bottomSearchFieldText
					searchJourneyViewModel.bottomSearchFieldText = tmp
				}
			}, label: {
				switch searchStopViewModel.state.status {
				case .loading:
					if type == searchStopViewModel.state.type {
						ProgressView()
					} else {
						image
					}
				default:
					image
				}
			})
			.padding(12)
			.foregroundColor(.primary)
	}
}
