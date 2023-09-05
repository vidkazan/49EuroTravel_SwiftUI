//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI

struct SearchStopsView: View {
	@EnvironmentObject private var viewModel : OldSearchLocationViewModel
	@EnvironmentObject private var viewModel2 : SearchJourneyViewModel
	@FocusState	private var textTopFieldIsFocused : Bool
	@FocusState	private var textBottomFieldIsFocused: Bool
	var body: some View {
		VStack{
			VStack {
				HStack {
					TextField(LocationDirectionType.departure.placeholder, text: $viewModel.searchLocationDataSource.topSearchFieldText)
						.focused($textTopFieldIsFocused)
						.onTapGesture {
							viewModel2.send(event: .onDepartureEdit)
							if !textTopFieldIsFocused {
								viewModel.searchLocationDataSource.topSearchFieldText = ""
								viewModel.updateSearchText(
									type: .departure
								)
							}
						}
						.onChange(of: viewModel.searchLocationDataSource.topSearchFieldText, perform: { text in
								if textTopFieldIsFocused {
									viewModel.updateSearchText(
										type: .departure)
								}
						})
						.onChange(of: textTopFieldIsFocused, perform: { val in
							if val == true {
								viewModel2.send(event: .onDepartureEdit)
								textBottomFieldIsFocused = false
							}
						})
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
					}, label: {
							Image(systemName: "location")
						}
					)
					.foregroundColor(.black)
				}
				.padding(10)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
				.shadow(radius: 1,y:1)
				if textTopFieldIsFocused {
					VStack {
						ForEach(viewModel.searchLocationDataSource.searchLocationDataDeparture) { stop in
							if let text = stop.name {
								Button(text){
										viewModel.updateSearchText(
											type: .departure
										)
									viewModel.updateSearchData(stop: stop, type: .departure)
									textTopFieldIsFocused = false
								}
								.foregroundColor(.black)
								.padding(5)
							}
						}
						.frame(maxWidth: .infinity,alignment: .leading)
					}
					.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
					.frame(maxWidth: .infinity,alignment: .leading)
				}
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			VStack {
				HStack {
					TextField(LocationDirectionType.arrival.placeholder, text: $viewModel.searchLocationDataSource.bottomSearchFieldText)
						.focused($textBottomFieldIsFocused)
						.onTapGesture {
							viewModel2.send(event: .onArrivalEdit)
							if !textBottomFieldIsFocused {
								viewModel.searchLocationDataSource.bottomSearchFieldText = ""
								viewModel.updateSearchText(
									type: .arrival
								)
							}
						}
						.onChange(of: viewModel.searchLocationDataSource.bottomSearchFieldText, perform: { text in
								if textBottomFieldIsFocused {
									viewModel.updateSearchText(
										type: .arrival)
								}
						})
						.onChange(of: textBottomFieldIsFocused, perform: { val in
							if val == true {
								viewModel2.send(event: .onArrivalEdit)
								textTopFieldIsFocused = false
							}
						})
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
						viewModel.switchStops()
						viewModel2.send(event: .onStopsSwitch)
					}, label: {
							Image(systemName: "arrow.up.arrow.down")
						}
					)
					.foregroundColor(.black)
				}
				.padding(10)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
				.shadow(radius: 1,y:1)
				if textBottomFieldIsFocused {
					VStack {
						ForEach(viewModel.searchLocationDataSource.searchLocationDataArrival) { stop in
							if let text = stop.name {
								Button(text){
									viewModel.updateSearchText(
										type: .arrival
									)
									viewModel.updateSearchData(stop: stop, type:.arrival)
									textBottomFieldIsFocused = false
								}
								.foregroundColor(.black)
								.padding(5)
							}
						}
						.frame(maxWidth: .infinity,alignment: .leading)
					}
					.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
					.frame(maxWidth: .infinity,alignment: .leading)
				}
			}
			.background(.thinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
		}
	}
}
