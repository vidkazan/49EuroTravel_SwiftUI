//
//  JourneyScrollViewHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewHeader: View {
	@ObservedObject var journeyViewModel : JourneyListViewModel
    var body: some View {
		HStack{
			Button("Reload", action: {
				journeyViewModel.send(event: .onReloadJourneys)
			})
			.foregroundColor(.secondary)
				.frame(maxWidth: 80)
				.padding(5)
				.font(.system(size: 17, weight: .medium))
//				.background(.ultraThinMaterial)
				.background(Color.chewGray10)
				.cornerRadius(10)
			Spacer()
			Button("Earlier", action: {
				journeyViewModel.send(event: .onEarlierRef)
			})
				.foregroundColor(.secondary)
				.frame(maxWidth: 80)
				.padding(5)
				.font(.system(size: 17, weight: .medium))
//				.background(.ultraThinMaterial)
				.background(Color.chewGray10)
				.cornerRadius(10)
		}
    }
}

//struct JourneyScrollViewHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        JourneyScrollViewHeader()
//    }
//}
