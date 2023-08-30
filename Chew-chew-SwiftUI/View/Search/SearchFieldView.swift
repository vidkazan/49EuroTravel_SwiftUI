//
//  SearchFieldView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct SearchFieldView: View {
	@EnvironmentObject private var viewModel : SearchLocationViewModel
	@FocusState	private var textFieldIsFocused	: Bool
	let placeholder : String
	let type : LocationDirectionType
	init(type : LocationDirectionType) {
		self.type = type
		self.placeholder = type.placeholder
		
	}
	var rightButton : Button<Image> {
		type == .departure ?
		Button(action: {
		}, label: {
			Image(systemName: "location")
		})
		:
		Button(action: {
			viewModel.switchStops()
		}, label: {
			Image(systemName: "arrow.up.arrow.down")
		})
	}
	var stops : [Stop] {
		type == .departure ? viewModel.searchLocationDataDeparture : viewModel.searchLocationDataArrival
	}
	
    var body: some View {
		VStack {
			HStack {
				TextField(self.placeholder, text: type == .departure ? $viewModel.topSearchFieldText : $viewModel.bottomSearchFieldText)
					.focused($textFieldIsFocused)
					.onTapGesture {
						if !textFieldIsFocused {
							switch type {
							case .departure:
								viewModel.topSearchFieldText = ""
							case .arrival:
								viewModel.bottomSearchFieldText = ""
							}
							viewModel.updateSearchText(
								text: (type == .departure) ? viewModel.topSearchFieldText : viewModel.bottomSearchFieldText ,
								type: type
							)
						}
					}
					.onChange(of: (type == .departure) ? viewModel.topSearchFieldText : viewModel.bottomSearchFieldText, perform: { text in
							if textFieldIsFocused {
								viewModel.updateSearchText(
									text: (type == .departure) ? viewModel.topSearchFieldText : viewModel.bottomSearchFieldText ,
									type: type)
							}
					})
					.font(.system(size: 17,weight: .semibold))
					.frame(maxWidth: .infinity,alignment: .leading)
				rightButton
					.foregroundColor(.black)
			}
			.padding(10)
			.background(.ultraThinMaterial)
			.cornerRadius(10)
			.shadow(radius: 1,y:1)
			
			VStack {
				if textFieldIsFocused {
					ForEach(stops) { stop in
						if let text = stop.name {
							Button(text){
									viewModel.updateSearchText(
										text: (type == .departure) ? viewModel.topSearchFieldText : viewModel.bottomSearchFieldText ,
										type: type
									)
									viewModel.updateSearchData(stop: stop, type: type)
									textFieldIsFocused = false
							}
							.foregroundColor(.black)
							.padding(5)
						}
					}
					.frame(maxWidth: .infinity,alignment: .leading)
				}
			}
			.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
			.frame(maxWidth: .infinity,alignment: .leading)
		}
		.background(.thinMaterial)
		.cornerRadius(10)
    }
		
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
		SearchFieldView(type: .arrival)
			.environmentObject(SearchLocationViewModel())
    }
}
