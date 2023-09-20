//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI


struct LegDetailsView: View {
	@ObservedObject var viewModel : LegDetailsViewModel
	var body : some View {
		VStack {
			VStack {
				if let stop = viewModel.state.leg.stopovers?.first {
					LegStopView(
						type: .origin(stop, viewModel.state.leg.line, viewModel.state.leg),
						vm: viewModel
					)
				}
				if viewModel.state.status == .stopovers {
					ForEach(viewModel.state.leg.stopovers ?? []) { stopover in
						if stopover != viewModel.state.leg.stopovers!.first,stopover != viewModel.state.leg.stopovers!.last {
							LegStopView(type: .stopover(stopover), vm: viewModel)
							}
						}
					}
				if let stop = viewModel.state.leg.stopovers?.last {
					LegStopView(
						type: .destination(stop),
						vm: viewModel
					)
				}
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
		.padding(5)
		.background(.ultraThinMaterial.opacity(0.5))
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
