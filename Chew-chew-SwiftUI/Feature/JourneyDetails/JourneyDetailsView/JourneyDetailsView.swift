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
	@State var bottomSheetIsPresented : Bool = false
	@State var actionSheetIsPresented : Bool = false
	// MARK: Init
	init(journeyDetailsViewModel : JourneyDetailsViewModel) {
		viewModel = journeyDetailsViewModel
	}
	var body: some View {
		VStack {
			AlertsView(alertVM: chewVM.alertViewModel)
			ZStack {
				VStack {
					// MARK: Header
					header()
						.animation(nil, value: viewModel.state.status)
						.padding(10)
					// MARK: LegDetails
					ScrollView() {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.viewData.legs) { leg in
								LegDetailsView(
									send: viewModel.send,
									vm: Model.shared.legDetailsViewModel(
										tripId: leg.tripId,
										isExpanded: false,
										viewData: leg
									))
								}
							}
						}
						.padding(10)
					}
					// MARK: LegDetails - sheet
					.sheet(
						isPresented: $bottomSheetIsPresented,
						onDismiss: {
							viewModel.send(event: .didCloseBottomSheet)
						},
						content: {
							switch viewModel.state.status {
							case .loadingLocationDetails,.locationDetails:
								MapSheet(viewModel: viewModel)
							case .loadingFullLeg, .fullLeg:
								FullLegSheet(viewModel: viewModel)
							default:
								Text("error \(viewModel.state.status.description)")
							}
						}
					)
					// MARK: LegDetails - action sheet
					.confirmationDialog("", isPresented: $actionSheetIsPresented) {
						if case .actionSheet(leg: let leg)=viewModel.state.status,
						   case .line = leg.legType {
							Button(action: {
								switch viewModel.state.status {
								case .actionSheet(leg: let leg):
									viewModel.send(event: .didTapBottomSheetDetails(leg: leg, type: .fullLeg))
								default:
									return
								}
							}, label: {
								Label("Show full leg", systemImage: "arrow.up.backward.and.arrow.down.forward.circle")
							})
							.foregroundColor(Color.primary)
						}
						Button(action: {
							switch viewModel.state.status {
							case .actionSheet(leg: let leg):
								viewModel.send(event: .didTapBottomSheetDetails(leg: leg, type: .locationDetails))
							default:
								return
							}
						}, label: {
							Label("Show map", systemImage: "map.circle")
						})
						
						.foregroundColor(Color.primary)
						Button(role: .cancel, action: {
							viewModel.send(event: .didCloseActionSheet)
						}, label: {
							Text("Cancel")
						})
						.foregroundColor(Color.primary)
					}
				}
				// MARK: Modifiers
				.background(Color.chewFillPrimary)
				.navigationBarTitle("Journey details", displayMode: .inline)
				.toolbar {
					toolbar()
				}
				.onAppear {
					viewModel.send(event: .didRequestReloadIfNeeded(ref: viewModel.state.data.viewData.refreshToken))
				}
				// MARK: Modifiers - onChange
				.onChange(of: viewModel.state.status, perform: { status in
					switch status {
					case .loading, .loadedJourneyData, .error, .changingSubscribingState,.loadingIfNeeded:
						bottomSheetIsPresented = false
						actionSheetIsPresented = false
					case .fullLeg,.loadingLocationDetails,.locationDetails,.loadingFullLeg:
						bottomSheetIsPresented = true
						actionSheetIsPresented = false
					case .actionSheet:
						bottomSheetIsPresented = false
						actionSheetIsPresented = true
					}
				})
			}
		}
	}

struct JourneyDetailsPreview : PreviewProvider {
	static var previews: some View {
		let model = Model.shared
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey
		if let mock = mock,
		   let viewData = constructJourneyViewData(
			   journey: mock,
			   depStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
			   arrStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
			   realtimeDataUpdatedAt: 0
		   ){
			JourneyDetailsView(
				journeyDetailsViewModel: model.journeyDetailsViewModel(
					journeyRef: viewData.refreshToken,
					viewData: viewData,
					stops: .init(departure: .init(), arrival: .init()),
					followList: [],
					chewVM: ChewViewModel()
				))
				.environmentObject(ChewViewModel())
		} else {
			Text("error")
		}
	}
}
