//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI

struct SearchStopsView: View {
	@EnvironmentObject  var searchJourneyViewModel : SearchJourneyViewModel
	@FocusState	 var textTopFieldIsFocused : Bool
	@FocusState	 var textBottomFieldIsFocused: Bool
	
	@ObservedObject var searchStopViewModel : SearchLocationViewModel
	
	init(searchStopViewModel: SearchLocationViewModel) {
		self.searchStopViewModel = searchStopViewModel
	}
	
	var body: some View {
		VStack{
			VStack {
				HStack {
					textField(
						type: .departure,
						text: searchJourneyViewModel.topSearchFieldText,
						textBinding: $searchJourneyViewModel.topSearchFieldText,
						focusBinding: $textTopFieldIsFocused,
						focus: textTopFieldIsFocused
					)
					rightButton(type: .departure)
				}
					.padding(10)
					.background(.ultraThinMaterial)
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
				stopList(type: .departure)
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			VStack {
				HStack {
					textField(
						type: .arrival,
						text: searchJourneyViewModel.bottomSearchFieldText,
						textBinding: $searchJourneyViewModel.bottomSearchFieldText,
						focusBinding: $textBottomFieldIsFocused,
						focus: textBottomFieldIsFocused
					)
					rightButton(type: .arrival)
				}
					.padding(10)
					.background(.ultraThinMaterial)
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
				stopList(type: .arrival)
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
		}
	}
}
