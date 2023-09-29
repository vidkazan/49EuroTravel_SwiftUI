//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let viewModel : JourneyDetailsViewModel
	var body: some View {
		VStack {
			header()
				.padding(10)
			ScrollView() {
				LazyVStack{
					ForEach(viewModel.state.data.legs) { leg in
						LegDetailsView(viewModel: .init(leg: leg), journeyDetailsViewModel: viewModel)
					}
				}
				.padding(10)
			}
		}
		Spacer()
	}
}
