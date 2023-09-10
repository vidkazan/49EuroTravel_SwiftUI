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
				.foregroundColor(.secondary)
				.frame(maxWidth: 80)
				.padding(5)
				.font(.system(size: 17, weight: .medium))
				.background(.ultraThinMaterial)
				.cornerRadius(10)
		}
    }
}

struct JourneyScrollViewFooter_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewFooter()
    }
}
