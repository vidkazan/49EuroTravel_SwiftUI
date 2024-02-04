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
	@State var firstAppear : Bool = true
	
	init(stops : DepartureArrivalPair, date: ChewDate,settings : ChewSettings) {
		self.journeyViewModel = JourneyListViewModel(
			date: date,
			settings: settings,
			stops: stops
	   )
	}
	var body: some View {
		VStack {
			switch journeyViewModel.state.status {
			case .loadingJourneyList:
				VStack {
					Spacer()
					JourneyListViewLoader()
					Spacer()
				}
			case .journeysLoaded,.loadingRef,.failedToLoadLaterRef,.failedToLoadEarlierRef:
				switch journeyViewModel.state.data.journeys.isEmpty {
				case true:
					JourneyListHeaderView(journeyViewModel: journeyViewModel)
					Spacer()
					Text("Connections not found")
						.padding(5)
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,alignment: .center)
					Spacer()
				case false:
					ScrollViewReader { val in
						ScrollView {
							LazyVStack(spacing: 5) {
								JourneyListHeaderView(journeyViewModel: journeyViewModel)
									.id(0)
								ForEach(journeyViewModel.state.data.journeys,id: \.id) { journey in
									JourneyCell(
										journey: journey,
										stops: journeyViewModel.state.data.stops
									)
								}
								.id(1)
								switch journeyViewModel.state.status {
								case .journeysLoaded, .failedToLoadEarlierRef:
									if journeyViewModel.state.data.laterRef != nil {
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
							.cornerRadius(10)
						}
						.refreshable {
							journeyViewModel.send(event: .onReloadJourneyList)
						}
						.onAppear {
							if firstAppear == true {
								val.scrollTo(1, anchor: .top)
								firstAppear.toggle()
							}
						}
					}
				}
			case .failedToLoadJourneyList(let error):
				JourneyListHeaderView(journeyViewModel: journeyViewModel)
				VStack {
					Spacer()
					Text(error.description)
						.padding(5)
						.chewTextSize(.big)
					Button(action: {
						journeyViewModel.send(event: .onLaterRef)
					}, label: {
						Image(.exclamationmarkCircle)
							.chewTextSize(.medium)
							.foregroundColor(.secondary)
					})
					Spacer()
				}
			}
		}
	}
}

struct JourneyListPreview : PreviewProvider {
	static var previews: some View {
		JourneyListView(stops: .init(departure: .init(), arrival: .init()), date: .now, settings: .init())
			.environmentObject(ChewViewModel())
	}
}
