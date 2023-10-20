//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyDetailsViewModel
	@State var bottomSheetIsPresented : Bool
	@State var actionSheetIsPresented : Bool
	init(token : String?,data : JourneyViewData,depStop: Stop?,arrStop: Stop?) {
		viewModel = JourneyDetailsViewModel(refreshToken: token, data: data,depStop: depStop,arrStop: arrStop)
		bottomSheetIsPresented = false
		actionSheetIsPresented = false
	}
	var body: some View {
		ZStack {
			VStack {
				header()
					.animation(nil, value: viewModel.state.status)
					.padding(10)
				switch viewModel.state.status {
				case .loading:
					Spacer()
					ProgressView()
					Spacer()
				case .loadedJourneyData,.locationDetails,.loadingLocationDetails,.actionSheet,.fullLeg,.loadingFullLeg:
					ScrollView() {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.legs) { leg in
								LegDetailsView(leg : leg, journeyDetailsViewModel: viewModel)
							}
						}
						.padding(10)
					}
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
								Text("error")
							}
						}
					)
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
				case .error(error: let error):
					Spacer()
					Label(error.description, systemImage: "exclamationmark.circle.fill")
					Spacer()
				}
			}
			.navigationBarTitle("Journey details", displayMode: .inline)
			.transition(.opacity)
			.animation(.easeInOut, value: viewModel.state.status)
			.toolbar {
				Button(action: {
					viewModel.send(event: .didTapReloadJourneys)
				}, label: {Image(systemName: "arrow.clockwise")})
			}
			.onChange(of: viewModel.state.status, perform: { status in
				switch status {
				case .loading, .loadedJourneyData, .error:
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
