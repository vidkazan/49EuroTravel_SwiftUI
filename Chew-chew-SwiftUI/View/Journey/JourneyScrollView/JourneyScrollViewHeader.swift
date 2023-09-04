//
//  JourneyScrollViewHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewHeader: View {
    var body: some View {
		HStack{
			FillableButton(text: "Reload")
				.frame(maxWidth: 80)
				.cornerRadius(10)
			Spacer()
			FillableButton(text: "Earlier")
				.frame(maxWidth: 80)
				.cornerRadius(10)
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}

struct JourneyScrollViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewHeader()
    }
}
