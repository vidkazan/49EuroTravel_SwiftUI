//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneyView: View {
	@EnvironmentObject var viewModel : OldSearchLocationViewModel
	@EnvironmentObject var viewModel2 : SearchJourneyViewModel
    var body: some View {
		VStack{
			switch viewModel.resultJourneysCollectionViewDataSourse.awaitingData {
			case true:
				JourneyScrollViewLoader()
			case false:
				ScrollViewReader { proxy in
					ScrollView(showsIndicators: false)  {
						if viewModel2.state == .journeysLoaded {
							JourneyScrollViewHeader()
								.id(-1)
							ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { (journey) in
								VStack {
									JourneyHeaderView(journey: journey)
									LegsView(journey : journey)
									BadgesView(badges: [.dticket])
								}
								.id(journey.id)
								.background(.ultraThinMaterial)
								.cornerRadius(10)
								.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
								.shadow(radius: 1,y:1)
								.frame(maxWidth: .infinity)
								.onAppear{
									proxy.scrollTo(0,anchor: .top)
								}
							} // forEach
							JourneyScrollViewFooter()
						}
					} // scroll view
				} // scrollViewReader
				.transition(.move(edge: .bottom))
				.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse)
			}
		} // VStack
		.transition(.move(edge: .bottom))
		.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse)
		.frame(maxWidth: .infinity)
		.cornerRadius(10)
    }
}
