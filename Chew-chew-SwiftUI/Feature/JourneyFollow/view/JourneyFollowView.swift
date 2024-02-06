//
//  JourneyFollowView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import SwiftUI

struct JourneyFollowView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyFollowViewModel
	
	init(viewModel: JourneyFollowViewModel) {
		self.viewModel = viewModel
	}
	var body: some View {
		Group {
			switch viewModel.state.status {
			case .updating:
				switch viewModel.state.journeys.count {
				case 0:
					ProgressView()
						.frame(maxWidth: .infinity,maxHeight: .infinity)
				default:
					followViewInner
				}
			default:
				switch viewModel.state.journeys.count {
				case 0:
					Text("You have no followed journeys")
						.chewTextSize(.big)
				default:
					followViewInner
					
				}
			}
		}
		.navigationBarTitle("Journey follow")
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension JourneyFollowView {
	var followViewInner : some View {
		List {
			Section("Active", content: {
				ForEach(
					viewModel.state.journeys
						.filter({$0.journeyViewData.time.statusOnReferenceTime(chewVM.referenceDate) == .active})
						.sorted(by: {$0.journeyViewData.time.timestamp.departure.planned ?? 0 < $1.journeyViewData.time.timestamp.departure.planned ?? 0
					}),
					id: \.id) { journey in
						listCell(journey: journey)
					}
					
			})
			.chewTextSize(.big)
			Section("Ongoing", content: {
				ForEach(
					viewModel.state.journeys
						.filter({
							switch $0.journeyViewData.time.statusOnReferenceTime(chewVM.referenceDate){
							case .ongoing,.ongoingFar,.ongoingSoon:
								return true
							default:
								return false
							}
						})
						.sorted(by: {$0.journeyViewData.time.timestamp.departure.planned ?? 0 < $1.journeyViewData.time.timestamp.departure.planned ?? 0
					}),
					id: \.id) { journey in
						listCell(journey: journey)
					}
			})
			.chewTextSize(.big)
			Section("Past", content: {
				ForEach(
					viewModel.state.journeys
						.filter({$0.journeyViewData.time.statusOnReferenceTime(chewVM.referenceDate) == .past})
						.sorted(by: {$0.journeyViewData.time.timestamp.departure.planned ?? 0 < $1.journeyViewData.time.timestamp.departure.planned ?? 0
					}),
					id: \.id) { journey in
						listCell(journey: journey)
					}
			})
		}
		.onAppear {
			UITableView.appearance().separatorStyle = .none
			UITableView.appearance().separatorColor = .gray
		}
		.chewTextSize(.big)
		.listRowSeparator(.hidden)
		.listSectionSeparator(.hidden)
		.listStyle(.insetGrouped)
		
	}
}

extension JourneyFollowView {
	func list(data : [JourneyFollowData]) -> some View {
		return ForEach(
			data.sorted(by: {
				$0.journeyViewData.time.timestamp.departure.planned ?? 0 < $1.journeyViewData.time.timestamp.departure.planned ?? 0
			}),
			id: \.id) { journey in
				listCell(journey: journey)
			}
	}
}

extension JourneyFollowView {
	func listCell(journey : JourneyFollowData) -> some View {
		let vm = Model.shared.journeyDetailViewModel(
			followId: journey.id,
			for: journey.journeyViewData.refreshToken,
			viewdata: journey.journeyViewData,
			stops: .init(departure: journey.depStop, arrival: journey.arrStop),
			chewVM: chewVM)
		return JourneyFollowCellView(journeyDetailsViewModel: vm)
			.swipeActions(edge: .leading) {
				Button {
					vm.send(event: .didTapReloadButton(id: journey.id, ref: journey.journeyViewData.refreshToken))
				} label: {
					Label("Reload", systemImage: "arrow.clockwise")
				}
				.tint(.chewFillGreenPrimary)
			}
			.swipeActions(edge: .trailing) {
				Button {
					print(">>> start delete",journey.id)
					vm.send(event: .didTapSubscribingButton(id: journey.id,ref: journey.journeyViewData.refreshToken, journeyDetailsViewModel: vm))
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
					JourneyFollowData(id: 0, journeyViewData: $0, depStop: .init(), arrStop: .init())
				},
				initialStatus: .idle
			))
			.environmentObject(ChewViewModel(referenceDate: .specificDate(data.last?.time.timestamp.departure.actualOrPlannedIfActualIsNil() ?? 0)))
		}
	}
}
