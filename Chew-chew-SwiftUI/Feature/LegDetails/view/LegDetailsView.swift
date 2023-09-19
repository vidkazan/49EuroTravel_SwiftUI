//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI


struct LegDetailsView: View {
	@ObservedObject var viewModelJourney : JourneyDetailsViewModel
	@ObservedObject var viewModel : LegDetailsViewModel
	
	var body : some View {
		VStack {
			ZStack {
				VStack {
					LegStopView(
						viewModel: viewModel,
						line: viewModel.state.leg.line,
						type: .departure,
						stopover: nil
					)
					if viewModel.state.status == .stopovers, let stopovers = viewModel.state.leg.stopovers {
						ForEach(stopovers) { stopover in
							if stopover != stopovers.first,stopover != stopovers.last {
								LegStopView(
									viewModel: viewModel,
									line: nil,
									type: .departure,
									stopover: stopover
								)
							}
						}
					}
					LegStopView(
						viewModel: viewModel,
						line: nil,
						type: .arrival,
						stopover: nil
					)
				}
				.background {
					HStack {
						Rectangle()
							.fill(.ultraThinMaterial.opacity(0.5))
							.frame(width: 20)
							.cornerRadius(8)
							.padding(5)
							.padding(.leading,15)
						Spacer()
					}
				}
			}
		}
		.padding(5)
		.background(.ultraThinMaterial.opacity(0.5))
		.overlay {
			viewModel.state.leg.reachable == false ?
			Color.black.opacity(0.7) :
			Color.clear
		}
		.cornerRadius(10)
	}
}

//struct JourneyDetails_Previews: PreviewProvider {
//	static var previews: some View {
//		LegDetailsView(
//			viewModelJourney: .init(refreshToken: "", data: .init(id: .init(), startPlannedTimeLabelText: "", startActualTimeLabelText: "", endPlannedTimeLabelText: "", endActualTimeLabelText: "", startDate: .now, endDate: .now, durationLabelText: "", legDTO: [], legs: [], sunEvents: [], isReachable: true, badges: [], refreshToken: nil)),
//			viewModel: .init(
//				leg: .init(
//					origin: .init(
//					type: nil,
//						 id: nil,
//						 name: "Neuss Hbf",
//						 address: nil,
//						 location: nil,
//						 products: nil
//					 ),
//					 destination: .init(
//						 type: nil,
//						 id: nil,
//						 name: "Minden",
//						 address: nil,
//						 location: nil,
//						 products: nil
//					 ),
//					 line: .init(
//						 type: nil,
//						 id: nil,
//						 fahrtNr: nil,
//						 name: "RE6",
//						 linePublic: nil,
//						 adminCode: nil,
//						 productName: nil,
//						 mode: nil,
//						 product: nil
//					 ),
//					 remarks: nil,
//					 departure: "2023-09-19T10:36:21Z",
//					 plannedDeparture: "2023-09-19T10:36:21Z",
//					 arrival: "2023-09-19T13:35:21Z",
//					 plannedArrival: "2023-09-19T13:30:21Z",
//					 departureDelay: 0,
//					 arrivalDelay: 0,
//					 reachable: true,
//					 tripId: nil,
//					 direction: "Buch",
//					 arrivalPlatform: "13",
//					 plannedArrivalPlatform: "13",
//					 departurePlatform: "1",
//					 plannedDeparturePlatform: "1",
//					 departurePrognosisType: nil,
//					 walking: false,
//					 stopovers: []
//			)
//			))
//	}
//}
//
