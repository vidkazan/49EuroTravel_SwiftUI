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
			if #available(iOS 16.0, *) {
				NavigationStack {
					sheet(data: data, type: type)
				}
				.presentationDetents(Set(makePresentationDetent(chewDetents: type.detents))
				)
			} else {
				NavigationView {
					sheet(data: data, type: type)
				}
			}
		}
	}
	
	@ViewBuilder func sheet(data : any SheetViewDataSource, type : SheetViewModel.SheetType) -> some View {
		SheetViewInner(
			data: data,
			type: type,
			closeSheet: closeSheet
		)
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle(type.description)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						closeSheet()
					}
				})
			}
	}
}

struct SheetViewInner : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
//	@ObservedObject var sheetVM : SheetViewModel = Model.shared.sheetViewModel
	let data : any SheetViewDataSource
	let type : SheetViewModel.SheetType
	let closeSheet : ()->Void
	var body: some View {
		Group {
				switch type {
				case .info:
					Text("info")
				case .settings:
					SettingsView(
						settings: chewViewModel.state.settings,
						closeSheet: closeSheet
					)
				case .date:
					if #available(iOS 16.0, *) {
						DatePickerView(
							date: chewViewModel.state.date.date.date,
							time: chewViewModel.state.date.date.date,
							closeSheet: closeSheet
						)
						.presentationDetents([.height(300),.large])
					} else {
						DatePickerView(
							date: chewViewModel.state.date.date.date,
							time: chewViewModel.state.date.date.date,
							closeSheet: closeSheet
						)
					}
				case .fullLeg:
					if let data = data as? FullLegViewDataSource {
						FullLegSheet(leg: data.leg)
					}
				case .mapDetails:
					if let data = data as? MapDetailsViewDataSource {
						MapDetailsView(
							mapRect: data.coordRegion,
							legs: data.mapLegDataList
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
						type: type
					)
				case .none:
					EmptyView()
				case .onboarding:
					Text("onboarding")
				case .remark:
					if let data = data as? RemarksViewDataSource {
						if #available(iOS 16.0, *) {
							RemarkSheet(remarks: data.remarks)
								.presentationDetents([.height(300),.large])
						} else {
							RemarkSheet(remarks: data.remarks)
						}
					}
				case .journeyDebug:
					if let data = data as? JourneyDebugViewDataSource {
						JourneyDebugView(legsDTO: data.legDTOs)
					}
				}
			}
	}
}

enum ChewPresentationDetent : Hashable {
	case large
	case medium
	case height(CGFloat)
}

@available(iOS 16.0, *)
func makePresentationDetent(chewDetents : [ChewPresentationDetent]) -> [PresentationDetent] {
	return chewDetents.map { chewDetent -> PresentationDetent in
		switch chewDetent {
		case .large:
			return .large
		case .medium:
			return .medium
		case .height(let cGFloat):
			return .height(cGFloat)
		}
	}
}
