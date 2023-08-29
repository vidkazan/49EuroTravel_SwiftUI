//
//  JourneyScrollViewHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewHeader: View {
    var body: some View {
		VStack {
			HStack{
				FillableButton(text: "Reload",isNotFillable: false)
					.frame(maxWidth: 80)
					.cornerRadius(10)
				Spacer()
				FillableButton(text: "Earlier")
					.frame(maxWidth: 80)
					.cornerRadius(10)
			}
		}
    }
}

struct JourneyScrollViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewHeader()
    }
}
