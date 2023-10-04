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
			case .journeysLoaded,.loadingRef:
				switch journeyViewModel.state.journeys.isEmpty {
				case true:
					Spacer()
					Text("connections not found")
						.padding(5)
						.foregroundColor(.secondary)
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .center)
				case false:
					ScrollView()  {
						LazyVStack{
							ForEach(journeyViewModel.state.journeys,id: \.id) { journey in
								NavigationLink(destination: {
									NavigationLazyView(JourneyDetailsView(viewModel: .init(refreshToken: journey.refreshToken, data: journey)))
								}, label: {
									JourneyCell(journey: journey)
								})	
							}
							ProgressView()
								.onAppear{
									journeyViewModel.send(event: .onLaterRef)
								}
								.frame(maxHeight: 100)
						}
					}
					.transition(.move(edge: .bottom))
					.animation(.interactiveSpring(), value: journeyViewModel.state.status)
				}
			case .failedToLoadJourneys(let error):
				Spacer()
				Text(error.description)
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
