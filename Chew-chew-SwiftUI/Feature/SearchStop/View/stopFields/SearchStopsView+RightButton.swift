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
//					searchStopViewModel.send(event: .didLocationButtonPressed)
					break
				case .arrival:
					chewViewModel.send(event: .onStopsSwitch)
					let tmp = chewViewModel.topSearchFieldText
					chewViewModel.topSearchFieldText = chewViewModel.bottomSearchFieldText
					chewViewModel.bottomSearchFieldText = tmp
				}
			}, label: {
				switch searchStopViewModel.state.status {
				case .loading:
					if type == searchStopViewModel.state.type {
						ProgressView()
					} else {
						image
					}
//				case .loadingLocation:
//					if type == .departure {
//						ProgressView()
//					} else {
//						image
//					}
//				case .loadedUserLocation:
//						image.foregroundColor(.green)
//							.onAppear{
//								guard case .loadedUserLocation(lat: let lat, long: let long) = searchStopViewModel.state.status else { return }
//								chewViewModel.send(
//									event: .onNewDeparture(.location(.init(
//										type: "location",
//										id: nil,
//										name: "My Location",
//										address: "My Location",
//										location: .init(
//											type: "location",
//											id: nil,
//											latitude: lat,
//											longitude: long
//										),
//										products: nil
//								))))
//							}
				case .idle,.loaded,.error:
					image
				}
			})
			.padding(12)
			.foregroundColor(.primary)
	}
}
