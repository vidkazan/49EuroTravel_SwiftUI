//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	var journey : JourneyCollectionViewDataSourse
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
	}
    var body: some View {
		GeometryReader { geo in
			ZStack {
				Rectangle()
					.frame(height:15)
					.cornerRadius(5)
					.foregroundColor(Color.init(uiColor: UIColor.lightGray))
				ForEach(journey.legs) { leg in
					LegView(leg: leg)
						.frame(
							width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
							height:25)
						.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
				}
			}
		}
		.frame(height:30)
		.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
    }
	
}

//struct LegsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LegsView()
//    }
//}
