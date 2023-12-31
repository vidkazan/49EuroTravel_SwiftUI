//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneyListView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyViewModel : JourneyListViewModel
	var body: some View {
		switch journeyViewModel.state.status {
		case .loadingJourneyList:
//				JourneyCell()
//					.redacted(reason: .placeholder)
			VStack {
				Spacer()
				JourneyScrollViewLoader()
				Spacer()
			}
		case .journeysLoaded,.loadingRef,.failedToLoadLaterRef,.failedToLoadEarlierRef:
			switch journeyViewModel.state.journeys.isEmpty {
			case true:
				Spacer()
				Text("connections not found")
					.padding(5)
					.chewTextSize(.big)
					.frame(maxWidth: .infinity,alignment: .center)
				Spacer()
			case false:
				ScrollView()  {
					LazyVStack{
						ForEach(journeyViewModel.state.journeys,id: \.id) { journey in
							NavigationLink(destination: {
								NavigationLazyView(
									JourneyDetailsView(
										journeyDetailsViewModel: JourneyDetailsViewModel(
											refreshToken: journey.refreshToken,
											data: journey,
											depStop: chewVM.state.depStop.stop,
											arrStop: chewVM.state.arrStop.stop,
											followList: chewVM.journeyFollowViewModel.state.journeys.map { elem in elem.journeyRef},
											chewVM: chewVM
										)
									)
								)
							}, label: {
								JourneyCell(journey: journey)
							})
						}
						switch journeyViewModel.state.status {
						case .journeysLoaded, .failedToLoadEarlierRef:
							if journeyViewModel.state.laterRef != nil {
								ProgressView()
									.onAppear{
										journeyViewModel.send(event: .onLaterRef)
									}
									.frame(maxHeight: 100)
							} else {
								Label("change the time of your search to find later connections", systemImage: "exclamationmark.circle")
									.chewTextSize(.medium)
							}
						case .loadingRef(let type):
							if type == .laterRef {
								ProgressView()
									.frame(maxHeight: 100)
							}
						case .failedToLoadLaterRef:
							Label("error: try reload", systemImage: "exclamationmark.circle")
							.onTapGesture {
								journeyViewModel.send(event: .onLaterRef)
							}
						case .loadingJourneyList, .failedToLoadJourneyList:
							Label("", systemImage: "exclamationmark.circle.fill")
						}
					}
				}
				.frame(maxWidth: .infinity)
				.transition(.opacity)
				.animation(.spring(), value: journeyViewModel.state.status)
				.cornerRadius(10)
			}
		case .failedToLoadJourneyList(let error):
			VStack {
				Spacer()
				Text("connections not found")
					.padding(5)
					.chewTextSize(.big)
				let _ = print(error)
				Button(action: {
					journeyViewModel.send(event: .onLaterRef)
				}, label: {
					Image(systemName: "exclamationmark.circle")
						.chewTextSize(.medium)
						.foregroundColor(.secondary)
				})
				Spacer()
			}
		}
	}
}
