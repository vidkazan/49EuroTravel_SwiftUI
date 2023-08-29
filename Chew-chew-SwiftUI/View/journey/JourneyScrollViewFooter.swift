//
//  JourneyScrollViewFooter.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewFooter: View {
    var body: some View {
		HStack{
			Spacer()
			FillableButton(text: "Later")
				.frame(maxWidth: 80)
				.cornerRadius(10)
		}
    }
}

struct JourneyScrollViewFooter_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewFooter()
    }
}
