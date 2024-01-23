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
				ProgressView()
					.frame(maxWidth: .infinity,maxHeight: .infinity)
			default:
				List(viewModel.state.journeys, id: \.journeyRef, rowContent: { journey in
					let vm = JourneyDetailsViewModel(
						refreshToken: journey.journeyRef,
						data: journey.journeyViewData,
						depStop: journey.depStop,
						arrStop: journey.arrStop,
						followList: viewModel.state.journeys.map { $0.journeyRef },
						chewVM: chewVM
					)
					JourneyFollowCellView(journeyDetailsViewModel: vm)
						.swipeActions(edge: .leading) {
							Button {
								vm.send(event: .didTapReloadButton)
							} label: {
								Label("Reload", systemImage: "arrow.clockwise")
							}
							.tint(.chewFillGreenPrimary)
						}
						.swipeActions(edge: .trailing) {
							Button {
								if let ref = vm.state.data.refreshToken {
									chewVM.journeyFollowViewModel.send(event: .didTapEdit(
										action: .deleting,
										journeyRef: ref,
										followData: nil,
										journeyDetailsViewModel: vm
									))
								}
							} label: {
								Label("Delete", systemImage: "xmark.bin.circle")
							}
							.tint(.chewFillRedPrimary)
						}
				})
				.navigationBarTitle("Journey follow")
				.navigationBarTitleDisplayMode(.inline)
				.listRowSeparator(.hidden)
				.listSectionSeparator(.hidden)
				.listItemTint(Color.clear)
			}
		}
		.background(Color.chewFillPrimary)
		.transition(.opacity)
		.animation(.spring().speed(2), value: viewModel.state.status)
	}
}


struct FollowPreviews: PreviewProvider {
	static var previews: some View {
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey
		if let mock = mock {
			let viewData = constructJourneyViewData(
				journey: mock,
				depStop:  .init(),
				arrStop:  .init(),
				realtimeDataUpdatedAt: 0
			)
			Group {
				JourneyFollowView(viewModel: .init(
					coreDataStore: .init(),
					journeys: [.init(
						journeyRef: viewData.refreshToken ?? "",
						journeyViewData: viewData,
						depStop: .init(),
						arrStop: .init()
					)],
					initialStatus: .idle
				))
				.environmentObject(ChewViewModel())
				JourneyFollowView(viewModel: .init(
					coreDataStore: .init(),
					journeys: []))
				.environmentObject(ChewViewModel())
			}
		} else {
			Text("error")
		}
	}
}
