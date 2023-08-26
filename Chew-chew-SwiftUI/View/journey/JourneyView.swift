//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct JourneyView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
    var body: some View {
		ScrollView {
			if viewModel.state == .onNewDataJourney {
				ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { journey in
					VStack {
						JourneyHeaderView(journey: journey)
						LegsView(journey : journey)
						BadgesView(badges: [.init(color: .green, name: "DeutschlandTicket")])
					}
					.background(Color.init(uiColor: .systemGray6))
					.cornerRadius(10)
					.frame(maxWidth: .infinity)
					.shadow(radius: 1,y:1)
				}
			}
		}
		Spacer()
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
