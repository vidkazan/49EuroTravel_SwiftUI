//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneysListView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyViewModel : JourneyListViewModel
	var body: some View {
		VStack{
			switch journeyViewModel.state.status {
			case .loadingJourneys:
				Spacer()
				JourneyScrollViewLoader()
			case .journeysLoaded,.loadingRef,.failedToLoadLaterRef,.failedToLoadEarlierRef:
				switch journeyViewModel.state.journeys.isEmpty {
				case true:
					Spacer()
					Text("connections not found")
						.padding(5)
						.foregroundColor(.secondary)
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,alignment: .center)
				case false:
					ScrollView()  {
						LazyVStack{
							ForEach(journeyViewModel.state.journeys,id: \.id) { journey in
								NavigationLink(destination: {
									NavigationLazyView(
										JourneyDetailsView(
											token: journey.refreshToken,
											data: journey,
											depStop: chewVM.state.depStop,
											arrStop: chewVM.state.arrStop
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
							case .loadingJourneys, .failedToLoadJourneys:
								Label("", systemImage: "exclamationmark.circle.fill")
							}
						}
					}
					.transition(.move(edge: .bottom))
					.animation(.spring(), value: journeyViewModel.state.status)
				}
			case .failedToLoadJourneys(let error):
				Spacer()
				VStack {
					Text("connections not found")
						.padding(5)
						.foregroundColor(.secondary)
						.chewTextSize(.big)
					let _ = print(error)
//					Text(error.description)
//						.font(.system(size: 8,weight: .semibold))
//						.padding(5)
//						.foregroundColor(.secondary)
					Button(action: {
						journeyViewModel.send(event: .onLaterRef)
					}, label: {
						Image(systemName: "exclamationmark.circle")
							.chewTextSize(.medium)
							.foregroundColor(.secondary)
					})
					
				}
			}
			Spacer()
		}
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: journeyViewModel.state.status)
		.frame(maxWidth: .infinity)
		.cornerRadius(10)
	}
}
