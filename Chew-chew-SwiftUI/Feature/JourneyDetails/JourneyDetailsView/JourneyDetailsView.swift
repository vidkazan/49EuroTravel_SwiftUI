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
	
	init(token : String?,data : JourneyViewData) {
		viewModel = JourneyDetailsViewModel(refreshToken: token, data: data)
	}
	var body: some View {
		ZStack {
			VStack {
				header()
					.padding(10)
				ScrollView() {
					LazyVStack(spacing: 0){
						ForEach(viewModel.state.data.legs) { leg in
							LegDetailsView(leg : leg, journeyDetailsViewModel: viewModel)
						}
					}
					.padding(10)
				}
			}
			if case .locationDetails(coordRegion: let reg, coordinates: let coords) = viewModel.state.status {
				let _ = print("reg")
				MapView(mapRect: reg, coords: coords,viewModel: viewModel)
			}
		}
	}
}
