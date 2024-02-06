//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit
struct JourneyDetailsView: View {
	
	// MARK: Fields
	
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyDetailsViewModel
	@State var sheetType : SheetType = .none
	
	// MARK: Init
	init(journeyDetailsViewModel : JourneyDetailsViewModel) {
		viewModel = journeyDetailsViewModel
	}
	var body: some View {
		VStack {
			ZStack {
				VStack {
					header()
						.padding(.horizontal,5)
						.padding(5)
					ScrollView {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.viewData.legs) { leg in
								LegDetailsView(
									send: viewModel.send,
									referenceDate: chewVM.referenceDate,
									openSheet: {type in
										sheetType = type
									},
									isExpanded: .collapsed,
									leg: leg
								)}
							}
						}
						.padding(10)
					}
					// MARK: LegDetails - sheet
					.sheet(
						isPresented: sheetType.sheetIsPresented,
						onDismiss: {
							viewModel.send(event: .didCloseBottomSheet)
							sheetType = .none
						},
						content: {
							switch sheetType {
							case .fullLeg:
								FullLegSheet(
									journeyViewModel: viewModel
								)
							case .map:
								MapSheet(viewModel: viewModel)
							case .none:
								EmptyView()
							}
						}
					)
				}
				// MARK: Modifiers
				.background(Color.chewFillPrimary)
				.navigationBarTitle("Journey details", displayMode: .inline)
				.toolbar { toolbar() }
				// MARK: Modifiers - onChange
				.onChange(of: sheetType, perform: { type in
					switch type {
					case .none:
						break
					case .map(let leg):
						viewModel.send(event: .didTapBottomSheetDetails(leg: leg, type: .locationDetails))
					case .fullLeg(let leg):
						viewModel.send(event: .didTapBottomSheetDetails(leg: leg, type: .fullLeg))
					}
				})
				.onReceive(viewModel.$state, perform: {state in
					if state.status == .loadedJourneyData {
						sheetType = .none
					}
				})
				.onAppear {
					viewModel.send(event: .didRequestReloadIfNeeded(
						id: viewModel.state.data.id,
						ref: viewModel.state.data.viewData.refreshToken,
						timeStatus: .active
					))
				}
			}
		}
	}

struct JourneyDetailsPreview : PreviewProvider {
	static var previews: some View {
		let mocks = [
			Mock.journeys.journeyNeussWolfsburgFirstCancelled.decodedData!.journey,
			Mock.journeys.journeyNeussWolfsburg.decodedData!.journey
		]
		ScrollView(.horizontal) {
			LazyHStack {
				ForEach(mocks,id: \.id) { mock in
					let viewData = mock.journeyViewData(
						depStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
						arrStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
						realtimeDataUpdatedAt: 0
					)
					JourneyDetailsView(
						journeyDetailsViewModel: JourneyDetailsViewModel(
							followId: 0,
							data: viewData!,
							depStop: .init(),
							arrStop: .init(),
							chewVM: .init()
						))
					.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData!.time.timestamp.departure.actual ?? 0) + 1000)))
				}
			}
		}
//		.previewDevice(PreviewDevice(.iPadMini6gen))
	}
}
