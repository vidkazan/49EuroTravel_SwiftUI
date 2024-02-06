//
//  JourneyScrollViewFooter.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewFooter: View {
	@ObservedObject var journeyViewModel : JourneyListViewModel
	var body: some View {
		HStack{
			Spacer()
			Button("Later", action: {
				journeyViewModel.send(event: .onLaterRef)
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
