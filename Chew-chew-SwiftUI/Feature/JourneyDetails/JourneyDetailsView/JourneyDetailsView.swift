//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyDetailsViewModel
	
	init(token : String?,data : JourneyViewData,depStop: StopType?,arrStop: StopType?) {
		viewModel = JourneyDetailsViewModel(refreshToken: token, data: data,depStop: depStop,arrStop: arrStop)
	}
	var body: some View {
		ZStack {
			VStack {
				header()
					.animation(nil, value: viewModel.state.status)
				.padding(10)
				switch viewModel.state.status {
				case .loading:
					Spacer()
					ProgressView()
					Spacer()
				case .loadedJourneyData,.locationDetails:
					ScrollView() {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.legs) { leg in
								LegDetailsView(leg : leg, journeyDetailsViewModel: viewModel)
							}
						}
						.padding(10)
					}
				case .error(error: let error):
					Spacer()
					Label(error.description, systemImage: "exclamationmark.circle.fill")
					Spacer()
				}
			}
			if case .locationDetails(coordRegion: let reg, coordinates: let coords) = viewModel.state.status {
				MapView(mapRect: reg, coords: coords,viewModel: viewModel)
					.transition(.move(edge: .bottom))
					.opacity(viewModel.state.status.description == "locationDetails" ? 1 : 0)
					.animation(.spring(), value: viewModel.state.status)
			}
		}
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: viewModel.state.status)
		.toolbar {
			Button(action: {
				viewModel.send(event: .didTapReloadJourneys)
			}, label: {Image(systemName: "arrow.clockwise")})
		}
	}
}
