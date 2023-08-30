//
//  JourneyScrollViewBody.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewBody: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
    var body: some View {
		ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { (journey) in
			VStack {
				JourneyHeaderView(journey: journey)
				LegsView(journey : journey)
				BadgesView(badges: [.init(color: UIColor(hue: 0.3, saturation: 1, brightness: 0.4, alpha: 1), name: "DeutschlandTicket")])
			}
			.id(journey.id)
			.background(.ultraThinMaterial)
			.cornerRadius(10)
			.frame(maxWidth: .infinity)
			.shadow(radius: 1,y:2)
			.onAppear{
				proxy.scrollTo(0,anchor: .top)
			}
		}
    }
}
