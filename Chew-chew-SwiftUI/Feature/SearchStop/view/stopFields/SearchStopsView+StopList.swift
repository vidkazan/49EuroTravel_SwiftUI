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
				if searchStopViewModel.state.status == .loaded {
					switch searchStopViewModel.state.stops.isEmpty {
					case true:
						Text("nothing found")
							.foregroundColor(.gray)
							.padding(5)
							.frame(maxWidth: .infinity,alignment: .center)
					case false:
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
								.foregroundColor(.black)
								.padding(5)
							}
						}
						.frame(maxWidth: .infinity,alignment: .leading)
					}
					
					
				}
				if case .error(let error) =  searchStopViewModel.state.status {
					Text(error.description)
						.foregroundColor(.gray)
						.padding(5)
						.frame(maxWidth: .infinity,alignment: .center)
					
				}
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}
