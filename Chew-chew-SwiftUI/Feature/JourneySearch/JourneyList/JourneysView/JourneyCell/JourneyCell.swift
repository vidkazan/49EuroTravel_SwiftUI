//
//  JourneyCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

struct JourneyCell: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let journey : JourneyViewData
	let stops : DepartureArrivalPair
	let isPlaceholder : Bool
	
	init(journey: JourneyViewData,stops : DepartureArrivalPair, isPlaceholder : Bool = false) {
		self.journey = journey
		self.stops = stops
		self.isPlaceholder = isPlaceholder
	}
	var body: some View {
		VStack {
			NavigationLink(destination: {
				let vm = Model.shared.journeyDetailViewModel(
					followId: Self.followID(journey: journey),
					 for: journey.refreshToken,
					 viewdata: journey,
					 stops: stops,
					 chewVM: chewVM
				)
				NavigationLazyView(
					JourneyDetailsView(journeyDetailsViewModel: vm)
				)
			}, label: {
				VStack {
					JourneyHeaderView(journey: journey)
					LegsView(journey : journey,progressBar: false)
						.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
				}
			})
			HStack(alignment: .center) {
				PlatformView(
					isShowingPlatormWord: false,
					platform: journey.legs.first?.legStopsViewData.first?.departurePlatform ?? .init()
				)
				Text(journey.legs.first?.legStopsViewData.first?.name ?? "")
					.chewTextSize(.medium)
					.tint(.primary)
				Spacer()
				BadgesView(badges: journey.badges)
			}
			.padding(7)
		}
		.background(Color.chewFillAccent.opacity(0.5))
		.overlay {
			if journey.isReachable == false {
				Color.primary.opacity(0.4)
			}
		}
		.redacted(reason: isPlaceholder ? .placeholder : [])
		.cornerRadius(10)
	}
	
	static func followID(journey : JourneyViewData) -> Int64 {
		let journeys = Model.shared.journeyFollowViewModel.state.journeys
		guard let followID = journeys.first(where: {
			$0.journeyViewData.refreshToken == journey.refreshToken
		})?.id else {
			return Int64(journey.refreshToken.hashValue)
		}
		return followID
		
	}
}

struct JourneyCellPreview: PreviewProvider {
	static var previews: some View {
		let mocks = [
			Mock.journeys.journeyNeussWolfsburg.decodedData,
			Mock.journeys.journeyNeussWolfsburgFirstCancelled.decodedData
		]
		VStack {
			ForEach(mocks,id: \.?.realtimeDataUpdatedAt){ mock in
				if let mock = mock,
				   let viewData = mock.journey.journeyViewData(
						depStop: .init(),
						arrStop: .init(),
						realtimeDataUpdatedAt: 0
					) {
					JourneyCell(journey: viewData,stops: .init(departure: .init(), arrival: .init()))
						.environmentObject(ChewViewModel())
				} else {
					Text("error")
				}
			}
		}
		.padding()
	}
}
