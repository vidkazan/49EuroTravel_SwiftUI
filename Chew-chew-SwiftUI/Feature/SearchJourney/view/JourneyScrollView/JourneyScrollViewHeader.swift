//
//  JourneyScrollViewHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewHeader: View {
	@EnvironmentObject var viewModel2 : SearchJourneyViewModel
    var body: some View {
		HStack{
			Button("Reload", action: {
				viewModel2.send(event: .onReloadJourneys)
			})
			.foregroundColor(.secondary)
				.frame(maxWidth: 80)
				.padding(5)
				.font(.system(size: 17, weight: .medium))
				.background(.ultraThinMaterial)
				.cornerRadius(10)
			Spacer()
			Button("Earlier", action: {
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

struct JourneyScrollViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        JourneyScrollViewHeader()
    }
}
