//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct JourneyCellView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
    var body: some View {
		switch viewModel.resultJourneysCollectionViewDataSourse.awaitingData {
		case true:
			VStack{
				Spacer()
				ProgressView()
				Spacer()
			}
			.transition(.move(edge: .bottom))
			.animation(.easeInOut, value: viewModel.resultJourneysCollectionViewDataSourse.journeys)
		case false:
			ScrollView {
				if viewModel.state == .onNewDataJourney {
					ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { journey in
						VStack {
							JourneyHeaderView(journey: journey)
							LegsView(journey : journey)
							BadgesView(badges: [.init(color: .green, name: "DeutschlandTicket")])
						}
						.background(.ultraThinMaterial)
						.cornerRadius(10)
						.frame(maxWidth: .infinity)
						.shadow(radius: 1,y:2)
					}
				}
			}
			.transition(.move(edge: .bottom))
			.animation(.easeInOut, value: viewModel.resultJourneysCollectionViewDataSourse.journeys)
//			Spacer()
		}
			
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyCellView()
    }
}
