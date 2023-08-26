//
//  SearchFieldView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct SearchFieldView: View {
	@FocusState			private var textFieldIsFocused : Bool
	@EnvironmentObject	private var viewModel : SearchLocationViewModel
	@State var fieldText = ""
	
	let placeholder : String
	let type : LocationDirectionType
	init(type : LocationDirectionType) {
		self.placeholder = type.placeholder
		self.type = type
	}
	
    var body: some View {
		VStack {
			TextField(self.placeholder, text: $fieldText)
				.focused($textFieldIsFocused)
				.onTapGesture {
					fieldText = ""
					viewModel.updateSearchText(text: fieldText, type: type)
				}
				.onChange(of: fieldText, perform: { text in
					if textFieldIsFocused {
						viewModel.updateSearchText(text: fieldText, type: type)
					}
				})
				.font(.system(size: 17))
				.padding(5)
			if textFieldIsFocused {
			ForEach(type == .departure ? viewModel.searchLocationDataDeparture : viewModel.searchLocationDataArrival) { stop in
					if let text = stop.name {
						Button(text){
							textFieldIsFocused = false
							fieldText = text
							viewModel.updateSearchData(stop: stop, type: type)
						}
						.foregroundColor(.black)
						.padding(5)
					}
				}
				.frame(maxWidth: .infinity,alignment: .leading)
			}
		}
		.padding(5)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
    }
		
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
		SearchFieldView(type: .departure)
    }
}
