//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyDetailsViewModel
	let data : JourneyCollectionViewDataSourse
	var body: some View {
		header()
			.padding(10)
		switch viewModel.state.status {
		case .loading:
			Spacer()
			ProgressView()
		case .loadedJourneyData(data: let data):
			Spacer()
			Text("loadded")
		case .error(error: let error):
			Spacer()
			Text(error.description)
		}
		Spacer()
	}
}

