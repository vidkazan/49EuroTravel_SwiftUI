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
	
	init(stops : DepartureArrivalPair, date: ChewViewModel.ChewDate,settings : ChewSettings) {
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
									NavigationLink(destination: {
										NavigationLazyView(JourneyDetailsView(journeyDetailsViewModel: JourneyDetailsViewModel(
											refreshToken: journey.refreshToken,
											data: journey,
											depStop: journeyViewModel.state.data.stops.departure,
											arrStop: journeyViewModel.state.data.stops.arrival,
											followList: chewVM.journeyFollowViewModel.state.journeys.map { $0.journeyRef },
											chewVM: chewVM
										)))
									}, label: {
										JourneyCell(journey: journey)
									})
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
					Text("connections not found")
						.padding(5)
						.chewTextSize(.big)
					let _ = print(error)
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
		let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
		if let mock = mock {
			let viewData = constructJourneyListViewData(
				journeysData: mock,
				depStop: .init(),
				arrStop: .init()
			)
			let data = JourneyListViewData(
				journeysViewData: viewData,
				data: mock,
				depStop: .init(),
				arrStop: .init()
			)
			let vm = JourneyListViewModel(
				stops: .init(departure: .init(), arrival: .init()),
				viewData: data
			)
			JourneyListView(stops: .init(departure: .init(), arrival: .init()), date: .now, settings: .init())
				.environmentObject(ChewViewModel())
		} else {
			Text("error")
		}
	}
}
