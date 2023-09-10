//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneysView: View {
	@EnvironmentObject var viewModel2 : SearchJourneyViewModel
    var body: some View {
		VStack{
			switch viewModel2.state.status {
			case .loadingJourneys:
				Spacer()
				JourneyScrollViewLoader()
			case .journeysLoaded:
				switch viewModel2.state.journeys.isEmpty {
				case true:
					Spacer()
					Text("connections not found")
						.padding(5)
						.foregroundColor(.secondary)
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .center)
				case false:
					ScrollViewReader { proxy in
						ScrollView(showsIndicators: false)  {
							if viewModel2.state.status == .journeysLoaded {
								JourneyScrollViewHeader()
									.id(-1)
								ForEach(viewModel2.state.journeys) { journey in
									JourneyCell(journey: journey)
								}
								.onAppear{
									proxy.scrollTo(0,anchor: .top)
								}
								JourneyScrollViewFooter()
							}
						}
					}
					.transition(.move(edge: .bottom))
					.animation(.interactiveSpring(), value: viewModel2.state.status)
				}
				
			case .idle,.editingDepartureStop,.editingArrivalStop,.datePicker,.journeyDetails:
				EmptyView()
			case .failedToLoadJourneys:
				Spacer()
				Text("failed to load journeys")
					.padding(5)
					.foregroundColor(.secondary)
					.font(.system(size: 17,weight: .semibold))
					.frame(maxWidth: .infinity,alignment: .center)
			}
			Spacer()
		}
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: viewModel2.state.status)
		.animation(.spring(), value: viewModel2.state.searchStopViewModel.state)
		.frame(maxWidth: .infinity)
		.cornerRadius(10)
    }
}
