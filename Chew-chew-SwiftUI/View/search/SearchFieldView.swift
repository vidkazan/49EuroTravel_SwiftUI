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
	@State	var fieldText : String = ""
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
				TextField(self.placeholder, text: $fieldText)
					.focused($textFieldIsFocused)
					.onTapGesture {
						viewModel.updateSearchText(text: fieldText, type: type)
						fieldText = ""
					}
					.onChange(of: fieldText, perform: { text in
						withAnimation{
							if textFieldIsFocused {
								viewModel.updateSearchText(text: fieldText, type: type)
							}
						}
						
					})
					.font(.system(size: 17))
					.frame(maxWidth: .infinity,alignment: .leading)
				rightButton
					.foregroundColor(.black)
			}
			.padding(5)
			if textFieldIsFocused {
				ForEach(stops) { stop in
					if let text = stop.name {
						Button(text){
							viewModel.updateSearchData(stop: stop, type: type)
							textFieldIsFocused = false
							fieldText = text
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
		.animation(.linear, value: stops.count)
    }
		
}

//struct SearchFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//		SearchFieldView(type: .departure,viewModel: view)
//    }
//}
