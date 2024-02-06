//
//  JourneySearchView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.02.24.
//

import Foundation
import SwiftUI


struct JourneySearchView : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool = false
	@State var sheetType : SheetType = .none
	var body: some View {
		VStack(spacing: 5) {
			SearchStopsView(vm: chewViewModel.searchStopsViewModel)
			TimeAndSettingsView(setSheetType: { sheetType = $0 })
			BottomView()
		}
		.padding(.horizontal,10)
		.background(Color.chewFillPrimary)
		.navigationTitle("ChewChew")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $bottomSheetIsPresented,content: { sheet })
		.onChange(of: sheetType, perform: { type in
			switch type {
			case .none:
				bottomSheetIsPresented = false
			default:
				bottomSheetIsPresented = true
			}
		})
	}
}

extension JourneySearchView {
	enum SheetType : String {
		case none
		case datePicker
		case settings
	}
}
