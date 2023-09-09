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
			Button("Later", action: {
				
			})
				.foregroundColor(Color.night)
				.frame(maxWidth: 80)
				.padding(5)
				.font(.system(size: 17, weight: .medium))
				.background(.ultraThinMaterial)
				.cornerRadius(10)
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}

struct JourneyScrollViewFooter_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewFooter()
    }
}
