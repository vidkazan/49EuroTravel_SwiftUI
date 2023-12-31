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
		ZStack {
			VStack {
				// MARK: Header
				header()
					.animation(nil, value: viewModel.state.status)
					.padding(10)
					// MARK: LegDetails
					ScrollView() {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.legs) { leg in
								LegDetailsView(leg : leg, journeyDetailsViewModel: viewModel)
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
					.confirmationDialog("Name", isPresented: $actionSheetIsPresented) {
						if case .actionSheet(leg: let leg)=viewModel.state.status, case .line=leg.legType {
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
				HStack {
					switch viewModel.refreshToken {
					case .none:
						Image(systemName: "bookmark.slash")
							.frame(width: 15,height: 15)
							.padding(5)
							.tint(.gray)
					case .some(let ref):
						Button(
							action: {
								viewModel.send(event: .didTapSubscribingButton)
								switch viewModel.state.isFollowed {
								case true:
									chewVM.journeyFollowViewModel.send(event: .didTapEdit(action: .deleting, journeyRef: ref, viewData: viewModel.state.data))
									chewVM.coreDataStore.deleteJourneyIfFound(journeyRef: ref)
								case false:
									chewVM.journeyFollowViewModel.send(event: .didTapEdit(action: .adding, journeyRef: ref, viewData: viewModel.state.data))
									chewVM.coreDataStore.addOrUpdateJourney(
										viewData: viewModel.state.data,
										depStop: viewModel.depStop,
										arrStop: viewModel.arrStop
									)
								}
							},
							label: {
								switch viewModel.state.isFollowed {
								case true:
									Image(systemName: "bookmark.fill")
										.frame(width: 15,height: 15)
										.padding(5)
								case false:
									Image(systemName: "bookmark")
										.frame(width: 15,height: 15)
										.padding(5)
								}
							}
						)
					}
					Button(
						action: {
							viewModel.send(event: .didTapReloadButton)
							chewVM.coreDataStore.addOrUpdateJourney(
								viewData: viewModel.state.data,
								depStop: viewModel.depStop,
								arrStop: viewModel.arrStop
							)
						},
						label: {
							switch viewModel.state.status {
							case .loading, .loadingIfNeeded:
								ProgressView()
									.frame(width: 15,height: 15)
									.padding(5)
							case .loadedJourneyData,
									.locationDetails,
									.loadingLocationDetails,
									.actionSheet,
									.fullLeg,
									.loadingFullLeg,
									.changingSubscribingState:
								Image(systemName: "arrow.clockwise")
									.frame(width: 15,height: 15)
									.padding(5)
							case .error:
								Image(systemName: "exclamationmark.circle")
									.frame(width: 15,height: 15)
									.padding(5)
							}
						}
					)
				}
			}
			.onAppear {
				viewModel.send(event: .didRequestReloadIfNeeded)
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
