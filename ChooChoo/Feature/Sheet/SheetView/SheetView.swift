//
//  SheetView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.02.24.
//

import Foundation
import SwiftUI
import MapKit

struct SheetView : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel = Model.shared.sheetViewModel
	let closeSheet : ()->Void
	var body: some View {
		switch sheetVM.state.status {
		case .error(let error):
			Text(error.localizedDescription)
		case .loading:
			ProgressView()
		case let .showing(type, data):
			switch type {
			case .settings:
				SettingsView(
					settings: chewViewModel.state.settings,
					closeSheet: closeSheet
				)
			case .date:
				if #available(iOS 16.0, *) {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: closeSheet
					)
					.presentationDetents([.height(300),.large])
				} else {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: closeSheet
					)
				}
			case .fullLeg:
				if let data = data as? FullLegViewDataSource {
					FullLegSheet(
						leg: data.leg,
						closeSheet: closeSheet
					)
				}
			case .mapDetails:
				if let data = data as? MapDetailsViewDataSource {
					MapDetailsView(
						mapRect: data.coordRegion,
						legs: data.mapLegDataList,
						closeSheet: closeSheet
					)
				}
			case .mapPicker(type: let type):
				let initialCoords = Model.shared.locationDataManager.locationManager.location?.coordinate ?? .init(latitude: 52, longitude: 7)
					MapPickerView(
						vm : MapPickerViewModel(.loadingNearbyStops(MKCoordinateRegion(
							center: initialCoords,
							latitudinalMeters: 0.01,
							longitudinalMeters: 0.01))),
						initialCoords: initialCoords,
						type: type,
						close: closeSheet
					)
			case .none:
				EmptyView()
			case .onboarding:
				Text("onboarding")
			case .remark:
				if let data = data as? RemarksViewDataSource {
					if #available(iOS 16.0, *) {
						RemarkSheet(remarks: data.remarks, closeSheet: closeSheet)
							.presentationDetents([.height(300),.large])
					} else {
						RemarkSheet(remarks: data.remarks, closeSheet: closeSheet)
					}
				}
			case .journeyDebug:
				if let data = data as? JourneyDebugViewDataSource {
					JourneyDebugView(legsDTO: data.legDTOs)
				} else {
					Text("JourneyDebugViewDataSource is nil")
				}
			}
		}
	}
}
