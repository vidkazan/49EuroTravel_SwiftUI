//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneysView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyViewModel : JourneyListViewModel
    var body: some View {
		VStack{
			switch journeyViewModel.state.status {
			case .loadingJourneys:
				Spacer()
				JourneyScrollViewLoader()
			case .journeysLoaded:
				switch journeyViewModel.state.journeys.isEmpty {
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
							if journeyViewModel.state.status == .journeysLoaded {
								JourneyScrollViewHeader(journeyViewModel: journeyViewModel)
									.id(-1)
								ForEach(journeyViewModel.state.journeys) { journey in
									NavigationLink(destination: {
										JourneyDetailsView()
											.environmentObject(chewVM)
									}, label: {
										JourneyCell(journey: journey)
									})
										
								}
								.onAppear{
									proxy.scrollTo(0,anchor: .top)
								}
								JourneyScrollViewFooter(journeyViewModel: journeyViewModel)
							}
						}
					}
					.transition(.move(edge: .bottom))
					.animation(.interactiveSpring(), value: journeyViewModel.state.status)
				}
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
		.animation(.spring(), value: journeyViewModel.state.status)
		.animation(.spring(), value: chewVM.state.searchStopViewModel.state)
		.frame(maxWidth: .infinity)
		.cornerRadius(10)
    }
}
