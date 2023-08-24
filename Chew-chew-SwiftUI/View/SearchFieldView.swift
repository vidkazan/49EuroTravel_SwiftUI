//
//  SearchFieldView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct SearchFieldView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	@State var departureText = ""
	let placeholder : String
	init(placeholder: String) {
		self.placeholder = placeholder
	}
	
    var body: some View {
		VStack {
			TextField(self.placeholder, text: $departureText)
				.padding(7)
				.background(Color(UIColor.systemGray6))
				.cornerRadius(12)
				.onTapGesture {
					departureText = ""
				}
				.onChange(of: departureText, perform: { text in
					viewModel.updateSearchText(text: departureText, isDeparture: true)
				})
		}
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(placeholder: "from")
    }
}
