//
//  MapPickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import SwiftUI
import MapKit


struct MapPickerView: View {
	let type : LocationDirectionType
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var vm : MapPickerViewModel
	let closeSheet : ()->Void
	@State private var mapCenterCoords: CLLocationCoordinate2D
	init(vm : MapPickerViewModel,initialCoords: CLLocationCoordinate2D, type : LocationDirectionType, close : @escaping ()->Void) {
		self.mapCenterCoords = initialCoords
		self.type = type
		self.closeSheet = close
		self.vm = vm
	}
	var body: some View {
		NavigationView {
			MapPickerUIView(
				vm: vm,
				mapCenterCoords: mapCenterCoords
			)
			.overlay(alignment: .bottomLeading) { overlay }
			.padding(5)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Close")
							.foregroundColor(.chewGray30)
					})
				})
			}
		}
	}
}

extension MapPickerView {
	var overlay : some View {
		Group {
			if let stop  = vm.state.data.selectedStop {
				VStack {
					HStack {
						Text("\(stop.name)")
							.padding(5)
							.chewTextSize(.big)
							.frame(maxWidth: .infinity,alignment: .leading)
						Button(action: {
							chewVM.send(event: .onNewStop(.location(stop), type))
							Model.shared.sheetViewModel.send(event: .didRequestShow(.none))
						}, label: {
							Text("Submit")
								.padding(5)
								.badgeBackgroundStyle(.blue)
								.chewTextSize(.big)
								.foregroundColor(.white)
						})
					}
					.padding(5)
					if let trips = vm.state.data.selectedStopTrips, !trips.isEmpty {
							ScrollView() {
								LazyVStack {
								ForEach(trips, id: \.id) { trip in
									HStack {
										BadgeView(.lineNumber(lineType: trip.lineViewData.type, num: trip.lineViewData.name))
											.frame(minWidth: 80,alignment: .leading)
										#warning("prognosed dorection")
										BadgeView(.legDirection(dir: trip.direction))
										Spacer()
										TimeLabelView(
											size: .big,
											arragement: .left,
											delayStatus: trip.time.departureStatus,
											time: trip.time.stringTimeValue.departure
										)
										.frame(minWidth: 50)
										let platform : Prognosed<String>? = trip.legStopsViewData.first?.departurePlatform ?? trip.legStopsViewData.last?.arrivalPlatform
//										let plannedPlatform = trip.legStopsViewData.first?.plannedDeparturePlatform ?? trip.legStopsViewData.last?.plannedArrivalPlatform
										HStack {
											if let platform = platform  {
												PlatformView(isShowingPlatormWord: false, platform: platform)
											}
										}
										.frame(width: 20)
									}
								}
							}
						}
						.frame(maxWidth: .infinity,maxHeight: 200)
					}
				}
				.padding(5)
				.badgeBackgroundStyle(.accent)
			}
		}
	}
}
