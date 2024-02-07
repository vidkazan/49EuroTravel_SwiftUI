//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

extension JourneyListView {
	func list() -> some View {
		return ScrollViewReader { val in
			ScrollView {
				LazyVStack(spacing: 5) {
					JourneyListHeaderView(journeyViewModel: journeyViewModel)
						.id(0)
					ForEach(journeyViewModel.state.data.journeys,id: \.id) { journey in
						JourneyCell(
							journey: journey,
							stops: journeyViewModel.state.data.stops
						)
					}
					.id(1)
					switch journeyViewModel.state.status {
					case .journeysLoaded, .failedToLoadEarlierRef:
						if journeyViewModel.state.data.laterRef != nil {
							ProgressView()
								.onAppear{
									journeyViewModel.send(event: .onLaterRef)
								}
								.frame(maxHeight: 100)
						} else {
							Label("change the time of your search to find later connections", systemImage: "exclamationmark.circle")
								.chewTextSize(.medium)
						}
					case .loadingRef(let type):
						if type == .laterRef {
							ProgressView()
								.frame(maxHeight: 100)
						}
					case .failedToLoadLaterRef:
						Label("error: try reload", systemImage: "exclamationmark.circle")
							.onTapGesture {
								journeyViewModel.send(event: .onLaterRef)
							}
					case .loadingJourneyList, .failedToLoadJourneyList:
						Label("", systemImage: "exclamationmark.circle.fill")
					}
				}
				.cornerRadius(10)
			}
			.refreshable {
				journeyViewModel.send(event: .onReloadJourneyList)
			}
			.onAppear {
				if firstAppear == true {
					val.scrollTo(1, anchor: .top)
					firstAppear.toggle()
				}
			}
		}
	}
}
