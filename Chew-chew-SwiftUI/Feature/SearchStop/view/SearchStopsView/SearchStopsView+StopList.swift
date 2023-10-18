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
			case .loaded:
				ScrollView{
					ForEach(searchStopViewModel.state.stops) { stop in
						HStack {
							Button(action: {
								switch type {
								case .departure:
									chewViewModel.send(event: .onNewDeparture(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								case .arrival:
									chewViewModel.send(event: .onNewArrival(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								}
							}, label: {
								Label(stop.name, systemImage: "train.side.front.car")
							})
							.foregroundColor(.primary)
							.padding(7)
							Spacer()
						}
					}
				}
			case .error(let error):
				Text(error.description)
					.foregroundColor(.secondary)
					.padding(5)
					.frame(maxWidth: .infinity,alignment: .center)
			case .idle,.loading:
				EmptyView()
			}
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}
