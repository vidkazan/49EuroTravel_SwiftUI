//
//  SearchFieldView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct SearchFieldView: View {
	@State var departureText = ""
	let placeholder : String
	init(placeholder: String) {
		self.placeholder = placeholder
	}
	
    var body: some View {
		TextField(self.placeholder, text: $departureText)
			.padding(7)
			.background(Color(UIColor.systemGray6))
			.cornerRadius(12)
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(placeholder: "from")
    }
}
