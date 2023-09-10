//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

extension SearchStopsView {
	func stopList(type : LocationDirectionType) -> some View {
		return VStack {
			switch searchStopViewModel.state.status {
			case .loaded,.loading:
					ForEach(searchStopViewModel.state.stops) { stop in
						if let text = stop.name {
							Button(text){
								switch type {
								case .departure:
									textTopFieldIsFocused = false
									searchJourneyViewModel.send(event: .onNewDeparture(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								case .arrival:
									textBottomFieldIsFocused = false
									searchJourneyViewModel.send(event: .onNewArrival(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								}
							}
							.foregroundColor(.primary)
							.padding(7)
						}
					}
					.frame(maxWidth: .infinity,alignment: .leading)
			case .error(let error):
				Text(error.description)
					.foregroundColor(.secondary)
					.padding(5)
					.frame(maxWidth: .infinity,alignment: .center)
			case .idle:
				EmptyView()
			}
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}
