//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI

struct JourneyHeaderView: View {
	let journey : JourneyCollectionViewDataSourse
	
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
	}
    var body: some View {
		ZStack {
			LinearGradient(colors: [.yellow,.blue], startPoint: UnitPoint(x: 0.1, y: 0), endPoint: UnitPoint(x: 0.9, y: 0))
			HStack{
				Text(journey.startTimeLabelText)
					.padding(7)
					.font(.system(size: 17))
					.fontWeight(.semibold)
					.frame(alignment: .leading)
				Spacer()
				Text(journey.durationLabelText)
					.font(.system(size: 12))
					.padding(7)
					.frame(alignment: .center)
				Spacer()
				Text(journey.endTimeLabelText)
					.padding(7)
					.font(.system(size: 17))
					.foregroundColor(.white)
					.fontWeight(.semibold)
					.frame(alignment: .leading)
			}
		}
		.cornerRadius(10)
    }
}

//struct JourneyHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        JourneyHeaderView()
//    }
//}
