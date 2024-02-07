//
//  SheetView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.02.24.
//

import Foundation
import SwiftUI

struct SheetView : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel
	var body: some View {
		Group {
			switch sheetVM.state.status {
			case .loading:
				ProgressView()
			case .hidden:
				EmptyView()
			case let .showing(type, data):
				switch type {
				case .settings:
					SettingsView(settings: chewViewModel.state.settings,setSheetType: {_ in})
				case .date:
					if #available(iOS 16.0, *) {
						DatePickerView(
							date: chewViewModel.state.date.date,
							time: chewViewModel.state.date.date,
							setSheetType: {_ in}
						)
						.presentationDetents([.height(300),.large])
					} else {
						DatePickerView(
							date: chewViewModel.state.date.date,
							time: chewViewModel.state.date.date,
							setSheetType: {_ in}
						)
					}
				case .fullLeg:
					if let data = data as? FullLegViewDataSource {
						FullLegSheetNew(leg: data.leg)
					}
				case .map:
					if let data = data as? MapDetailsViewDataSource {
						MapSheetNew(
							mapRect: data.coordRegion,
							stops: data.stops,
							route: data.route
						)
					}
				default:
					Text("some other sheet")
				}
			}
		}
	}
}
