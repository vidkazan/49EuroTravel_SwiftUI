//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI


struct JourneyView: View {
	@EnvironmentObject var viewModel2 : SearchJourneyViewModel
    var body: some View {
		VStack{
			switch viewModel2.state.status {
			case .loadingJourneys:
				Spacer()
				JourneyScrollViewLoader()
				Spacer()
			case .journeysLoaded:
				switch viewModel2.state.journeys.isEmpty {
				case true:
					Spacer()
					Text("connections not found")
						.padding(5)
						.foregroundColor(.black.opacity(0.7))
						.font(.system(size: 17,weight: .semibold))
						.frame(maxWidth: .infinity,alignment: .center)
					Spacer()
				case false:
					ScrollViewReader { proxy in
						ScrollView(showsIndicators: false)  {
							if viewModel2.state.status == .journeysLoaded {
								JourneyScrollViewHeader()
									.id(-1)
								ForEach(viewModel2.state.journeys) { (journey) in
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
					.animation(.interactiveSpring(), value: viewModel2.state.status)
				}
				
			case .idle,.editingDepartureStop,.editingArrivalStop,.datePicker,.journeyDetails:
				Spacer()
			case .failedToLoadJourneys:
				Text("failed to load journeys")
				Spacer()
			}
		} // VStack
		.transition(.move(edge: .bottom))
		.animation(.interactiveSpring(), value: viewModel2.state.status)
		.frame(maxWidth: .infinity)
		.cornerRadius(10)
    }
}
