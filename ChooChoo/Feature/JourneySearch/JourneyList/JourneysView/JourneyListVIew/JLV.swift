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
	
	init(stops : DepartureArrivalPair, date: SearchStopsDate,settings : Settings) {
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
				loading()
			case .journeysLoaded,.loadingRef,.failedToLoadLaterRef,.failedToLoadEarlierRef:
				switch journeyViewModel.state.data.journeys.isEmpty {
				case true:
					notFound()
				case false:
					list()
				}
			case .failedToLoadJourneyList(let error):
				ErrorView(
					viewType: .error,
					msg: Text(error.description),
					action: nil
				)
			}
		}
		.overlay(alignment: .bottom, content: {
			Button(action: {
				chewVM.send(event: .didTapCloseJourneyList)
			}, label: {
				Label(title: {
					Text("Clear", comment: "JourneyListView: overlay button name")
				}, icon: {
					Image(systemName: "xmark.circle")
				})
			})
			.padding(5)
			.foregroundStyle(.secondary)
			.chewTextSize(.big)
			.background(.thinMaterial)
			.cornerRadius(10)
			.frame(maxHeight: 43)
			.shadow(radius: 5)
			.padding(.bottom,20)
		})
	}
}

extension JourneyListView {
	func loading() -> some View {
		return Group {
			VStack {
				Spacer()
				ProgressView()
//				JourneyListViewLoader()
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

extension JourneyListView {
	func notFound() -> some View {
		return Group {
//			JourneyListHeaderView(journeyViewModel: journeyViewModel)
			Spacer()
			Text("Connections not found",comment: "JourneyListView: empty state")
				.padding(5)
				.chewTextSize(.big)
				.frame(maxWidth: .infinity,alignment: .center)
			Spacer()
		}
	}
}


struct JourneyListPreview : PreviewProvider {
	static var previews: some View {
		JourneyListView(
			stops: .init(departure: .init(), arrival: .init()), 
			date: .init(date: .now, mode: .departure),
			settings: .init()
		)
			.environmentObject(ChewViewModel())
	}
}

struct ErrorView : View {
	enum ViewType : String,Hashable, CaseIterable {
		case error
		case empty
	}
	let viewType : ViewType
	let msg : Text
	let action : (() -> Void)?
	var body: some View {
		Group {
			VStack {
				Spacer()
				Label(
					title: {
						msg
							.padding(5)
							.foregroundStyle(.secondary)
							.chewTextSize(.big)
					},
					icon: {
						Image(viewType == .error ? ChewSFSymbols.exclamationmarkCircle : ChewSFSymbols.infoCircle)
							.foregroundStyle(.secondary)
					}
				)
				.frame(maxWidth: 300,alignment: .center)
				if let action = action {
					Button(action: action, label: {
						Image(.exclamationmarkCircle)
							.chewTextSize(.big)
							.foregroundStyle(.secondary)
					})
				}
				Spacer()
			}
		}
	}
}
