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
	init(
		vm : MapPickerViewModel,
		initialCoords: CLLocationCoordinate2D,
		type : LocationDirectionType,
		close : @escaping ()->Void
	) {
		self.mapCenterCoords = initialCoords
		self.type = type
		self.closeSheet = close
		self.vm = vm
	}
	var body: some View {
		NavigationView {
			MapPickerUIView(vm: vm,mapCenterCoords: mapCenterCoords)
				.overlay(alignment: .bottomLeading) { overlay }
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
				.cornerRadius(10)
				.padding(5)
				.navigationTitle("Map picker")
				.navigationBarTitleDisplayMode(.inline)
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
								.frame(height: 40)
								.badgeBackgroundStyle(.blue)
								.chewTextSize(.big)
								.foregroundColor(.white)
						})
					}
					if let trips = vm.state.data.selectedStopTrips, !trips.isEmpty {
						// TODO: next version: feature:
						VStack {
							ScrollView {
								LazyVStack {
									ForEach(trips, id: \.id) { trip in
										HStack {
											BadgeView(.lineNumber(lineType: trip.lineViewData.type, num: trip.lineViewData.name))
												.frame(minWidth: 80,alignment: .leading)
											#warning("prognosed direction")
											BadgeView(.legDirection(dir: trip.direction,strikethrough: false))
											Spacer()
											TimeLabelView(
												size: .big,
												arragement: .left,
												delayStatus: trip.time.departureStatus,
												time: trip.time.date.departure
											)
											.frame(minWidth: 50)
											let platform = trip.legStopsViewData.first?.departurePlatform ?? trip.legStopsViewData.last?.arrivalPlatform
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
						}
						.frame(maxWidth: .infinity,minHeight: 0,maxHeight: 120)
					}
				}
				.padding(5)
				.badgeBackgroundStyle(.accent)

			}
		}
		.padding(5)
	}
}


struct MapPicker_Previews: PreviewProvider {
	static var previews: some View {
		MapPickerView(
			vm: .init(.idle),
			initialCoords: .init(latitude: 51.2, longitude: 6.68),
			type: .departure,
			close: {}
		)
	}
}
