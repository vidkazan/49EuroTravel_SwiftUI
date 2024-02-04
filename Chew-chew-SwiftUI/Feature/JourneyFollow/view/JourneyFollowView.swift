//
//  JourneyFollowView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import SwiftUI

func splitArray(array: [JourneyFollowData], referenceTime : ChewDate) -> ([JourneyFollowData], [JourneyFollowData], [JourneyFollowData]) {
	var section1 = [JourneyFollowData]()
	var section2 = [JourneyFollowData]()
	var section3 = [JourneyFollowData]()
	
	array.forEach { j in
		switch j.journeyViewData.time.statusOnReferenceTime(referenceTime) {
		case .ongoing:
			section1.append(j)
		case .active:
			section2.append(j)
		case .past:
			section3.append(j)
		}
	}
	
	return (section1, section2, section3)
}


struct JourneyFollowView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyFollowViewModel
	init(viewModel: JourneyFollowViewModel) {
		self.viewModel = viewModel
	}
	var body: some View {
//		LazyVStack {
		Group {
			switch viewModel.state.status {
			case .updating:
				ProgressView()
					.frame(maxWidth: .infinity,maxHeight: .infinity)
			default:
				switch viewModel.state.journeys.count {
				case 0:
					Text("You have no followed journeys")
						.chewTextSize(.big)
				default:
					let splittedData = splitArray(array: viewModel.state.journeys, referenceTime: chewVM.referenceDate)
					List {
						Section("Active", content: {
							list(data: splittedData.1)
						})
						.chewTextSize(.big)
						Section("Ongoing", content: {
							list(data: splittedData.0)
						})
						.chewTextSize(.big)
						Section("Past", content: {
							list(data: splittedData.2)
						})
					}
					.chewTextSize(.big)
					.listRowSeparator(.hidden)
					.listSectionSeparator(.hidden)
					.listItemTint(Color.clear)
					.listStyle(.insetGrouped)
				}
			}
		}
		.navigationBarTitle("Journey follow")
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension JourneyFollowView {
	func list(data : [JourneyFollowData]) -> some View {
		return ForEach(
			data.sorted(by: {
				$0.journeyViewData.time.timestamp.departure.planned ?? 0 < $1.journeyViewData.time.timestamp.departure.planned ?? 0
			}),
			id: \.journeyRef) { journey in
				listCell(journey: journey)
			}
	}
}

extension JourneyFollowView {
	func listCell(journey : JourneyFollowData) -> some View {
		let vm = Model.shared.journeyDetailViewModel(
			for: journey.journeyRef,
			viewdata: journey.journeyViewData,
			stops: .init(departure: journey.depStop, arrival: journey.arrStop),
			chewVM: chewVM)
		return JourneyFollowCellView(journeyDetailsViewModel: vm)
			.swipeActions(edge: .leading) {
				Button {
					vm.send(event: .didTapReloadButton(ref: journey.journeyRef))
				} label: {
					Label("Reload", systemImage: "arrow.clockwise")
				}
				.tint(.chewFillGreenPrimary)
			}
			.swipeActions(edge: .trailing) {
				Button {
					vm.send(event: .didTapSubscribingButton(ref: journey.journeyRef, journeyDetailsViewModel: vm))
				} label: {
					Label("Delete", systemImage: "xmark.bin.circle")
				}
				.tint(.chewFillRedPrimary)
			}
	}
}

struct FollowPreviews: PreviewProvider {
	static var previews: some View {
		if let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData {
			let data = constructJourneyListViewData(
				journeysData: mock,
				depStop:  .init(),
				arrStop:  .init()
			)
				JourneyFollowView(viewModel: .init(
					coreDataStore: .init(),
					journeys: data.map {
						JourneyFollowData(journeyRef: $0.refreshToken, journeyViewData: $0, depStop: .init(), arrStop: .init())
					},
					initialStatus: .idle
				))
				.environmentObject(ChewViewModel(referenceDate: .specificDate(data.last?.time.timestamp.departure.actualOrPlannedIfActualIsNil() ?? 0)))
		}
	}
}
