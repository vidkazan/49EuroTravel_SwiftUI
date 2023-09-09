//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI

struct SearchStopsView: View {
	@EnvironmentObject  var searchJourneyViewModel : SearchJourneyViewModel
	@ObservedObject var searchStopViewModel : SearchLocationViewModel
	@FocusState	 var textTopFieldIsFocused : Bool
	@FocusState	 var textBottomFieldIsFocused: Bool
	
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
				if searchStopViewModel.state.type == .departure {
					stopList(type: .departure)
						.transition(.move(edge: .bottom))
						.animation(.spring(), value: searchStopViewModel.state)
				}
					
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
//			.transition(.move(edge: .bottom))
//			.animation(.spring(), value: searchStopViewModel.state)
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
				if searchStopViewModel.state.type == .arrival {
					stopList(type: .arrival)
						.transition(.move(edge: .bottom))
						.animation(.spring(), value: searchStopViewModel.state)
				}
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
//			.transition(.move(edge: .bottom))
//			.animation(.spring(), value: searchStopViewModel.state)
		}
	}
}
