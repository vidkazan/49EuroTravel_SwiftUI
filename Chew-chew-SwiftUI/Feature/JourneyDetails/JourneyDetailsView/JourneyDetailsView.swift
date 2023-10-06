//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var viewModel : JourneyDetailsViewModel
	var ids = Set<UUID?>()
	
	init(token : String?,data : JourneyViewData) {
		viewModel = JourneyDetailsViewModel(refreshToken: token, data: data)
	}
	
	var body: some View {
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
		Spacer()
	}
}
