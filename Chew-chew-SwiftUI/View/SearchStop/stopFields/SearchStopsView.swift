//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI

struct SearchStopsView: View {
	@EnvironmentObject  var searchJourneyViewModel : SearchJourneyViewModel
	@EnvironmentObject  var searchStopViewModel : SearchLocationViewModel
	@FocusState	 var textTopFieldIsFocused : Bool
	@FocusState	 var textBottomFieldIsFocused: Bool
//	@State var textFieldTopText : String = ""
//	@State var textFieldBottomText : String = ""
	var body: some View {
		VStack{
			VStack {
				HStack {
					textField(
						type: .departure,
						text: searchStopViewModel.topSearchFieldText,
						textBinding: $searchStopViewModel.topSearchFieldText,
						focusBinding: $textTopFieldIsFocused,
						focus: textTopFieldIsFocused
					)
					rightButton(type: .departure)
				}
				.padding(10)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
				.shadow(radius: 1,y:1)
				if case .editingDepartureStop = searchJourneyViewModel.state {
					stopList(type: .departure)
				}
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			VStack {
				HStack {
					textField(
						type: .arrival,
						text: searchStopViewModel.bottomSearchFieldText,
						textBinding: $searchStopViewModel.bottomSearchFieldText,
						focusBinding: $textBottomFieldIsFocused,
						focus: textBottomFieldIsFocused
					)
					rightButton(type: .arrival)
				}
				.padding(10)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
				.shadow(radius: 1,y:1)
				if case .editingArrivalStop = searchJourneyViewModel.state {
					stopList(type: .arrival)
				}
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
		}
	}
}
