//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct FeatureView: View {
	enum SheetType : String {
		case none
		case datePicker
		case settings
	}
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool = false
	@State var sheetType : SheetType = .none
	var body: some View {
		TabView {
			Group {
				VStack(spacing: 5) {
					SearchStopsView(vm: chewViewModel.searchStopsViewModel)
					TimeAndSettingsView(setSheetType: { sheetType = $0 })
					BottomView()
				}
				.padding(.horizontal,10)
				.navigationTitle("ChewChew")
				.navigationBarTitleDisplayMode(.inline)
				.sheet(isPresented: $bottomSheetIsPresented,content: { sheet })
				.onReceive(chewViewModel.$state, perform: onStateChange)
				.onChange(of: sheetType, perform: { type in
					switch type {
					case .none:
						bottomSheetIsPresented = false
					default:
						bottomSheetIsPresented = true
					}
				})
				.background(Color.chewFillPrimary)
			}
			.tabItem {
				Label("Search", systemImage: "magnifyingglass")
			}
			JourneyFollowView(viewModel: chewViewModel.journeyFollowViewModel)
			.tabItem {
				Label("Follow", systemImage: "train.side.front.car")
			}
		}
	}
}
