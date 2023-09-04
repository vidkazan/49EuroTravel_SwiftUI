//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI

struct SearchStopsView: View {
	@EnvironmentObject private var viewModel : SearchLocationViewModel
	@EnvironmentObject private var viewModel2 : SearchStopViewModel
	@FocusState	private var textTopFieldIsFocused	: Bool
	@FocusState	private var textBottomFieldIsFocused	: Bool
	var body: some View {
		VStack{
			VStack {
				HStack {
					TextField(LocationDirectionType.departure.placeholder, text: $viewModel.searchLocationDataSource.topSearchFieldText)
						.focused($textTopFieldIsFocused)
						.onTapGesture {
							if !textTopFieldIsFocused {
								viewModel.searchLocationDataSource.topSearchFieldText = ""
								viewModel.updateSearchText(
									text: viewModel.searchLocationDataSource.topSearchFieldText,
									type: .departure
								)
							}
						}
						.onChange(of: viewModel.searchLocationDataSource.topSearchFieldText, perform: { text in
								if textTopFieldIsFocused {
									viewModel.updateSearchText(
										text: viewModel.searchLocationDataSource.topSearchFieldText,
										type: .departure)
			//								viewModel2.send(event: .onSearchFieldDidEdited((type == .departure) ? viewModel.searchLocationDataSource.topSearchFieldText : viewModel.searchLocationDataSource.bottomSearchFieldText))
								}
						})
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
					}, label: {
						switch viewModel2.state {
						case .loading:
							ProgressView()
						default:
							Image(systemName: "location")
						}
					})
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
											text: viewModel.searchLocationDataSource.topSearchFieldText,
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
							if !textBottomFieldIsFocused {
								viewModel.searchLocationDataSource.bottomSearchFieldText = ""
								viewModel.updateSearchText(
									text: viewModel.searchLocationDataSource.bottomSearchFieldText ,
									type: .arrival
								)
							}
						}
						.onChange(of: viewModel.searchLocationDataSource.bottomSearchFieldText, perform: { text in
								if textBottomFieldIsFocused {
									viewModel.updateSearchText(
										text: viewModel.searchLocationDataSource.bottomSearchFieldText ,
										type: .arrival)
			//								viewModel2.send(event: .onSearchFieldDidEdited((type == .departure) ? viewModel.searchLocationDataSource.topSearchFieldText : viewModel.searchLocationDataSource.bottomSearchFieldText))
								}
						})
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
						viewModel.switchStops()
					}, label: {
						switch viewModel2.state {
						case .loading:
							ProgressView()
						default:
							Image(systemName: "arrow.up.arrow.down")
						}
					})
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
											text: viewModel.searchLocationDataSource.bottomSearchFieldText,
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
