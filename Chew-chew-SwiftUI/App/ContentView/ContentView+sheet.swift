//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

extension FeatureView {
	var sheet : some View {
		Group {
			switch sheetType {
			case .datePicker:
				if #available(iOS 16.0, *) {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						setSheetType: {sheetType = $0}
					)
					.presentationDetents([.height(300),.large])
				} else {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						setSheetType: {sheetType = $0}
					)
				}
			case .settings:
				SettingsView(settings: chewViewModel.state.settings,setSheetType: {sheetType = $0})
			case .none:
				EmptyView()
			}
			
//			switch chewViewModel.state.status {
//			case .sheet(let type):
//				switch type {
//				case .settings:
//					SettingsView(settings: chewViewModel.state.settings)
//				case .date:
//					if #available(iOS 16.0, *) {
//						DatePickerView(
//							date: chewViewModel.state.date.date,
//							time: chewViewModel.state.date.date
//						)
//						.presentationDetents([.height(300),.large])
//					} else {
//						DatePickerView(
//							date: chewViewModel.state.date.date,
//							time: chewViewModel.state.date.date
//						)
//					}
//				}
//			default:
//				EmptyView()
//			}
		}
	}
}
