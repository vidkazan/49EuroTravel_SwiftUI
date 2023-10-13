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
	@State var bottomSheetIsPresented : Bool
	init(token : String?,data : JourneyViewData,depStop: StopType?,arrStop: StopType?) {
		viewModel = JourneyDetailsViewModel(refreshToken: token, data: data,depStop: depStop,arrStop: arrStop)
		bottomSheetIsPresented = false
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
				case .loadedJourneyData,.locationDetails,.loadingLocationDetails:
					ScrollView() {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.legs) { leg in
								LegDetailsView(leg : leg, journeyDetailsViewModel: viewModel)
							}
						}
						.padding(10)
					}
					.sheet(isPresented: $bottomSheetIsPresented, content: {
						switch viewModel.state.status {
						case .loadingLocationDetails,.locationDetails:
							MapSheet(viewModel: viewModel)
						case .loading, .loadedJourneyData, .error:
							EmptyView()
						}
					})
				case .error(error: let error):
					Spacer()
					Label(error.description, systemImage: "exclamationmark.circle.fill")
					Spacer()
				}
			}
		}
		.navigationBarTitle("Journey details", displayMode: .inline)
		.transition(.opacity)
		.animation(.easeInOut, value: viewModel.state.status)
		.toolbar {
			Button(action: {
				viewModel.send(event: .didTapReloadJourneys)
			}, label: {Image(systemName: "arrow.clockwise")})
		}
		.onChange(of: viewModel.state.status, perform: { status in
			switch status {
			case .loadingLocationDetails,.locationDetails:
				bottomSheetIsPresented = true
			case .loading, .loadedJourneyData, .error:
				bottomSheetIsPresented = false
			}
		})
	}
}
