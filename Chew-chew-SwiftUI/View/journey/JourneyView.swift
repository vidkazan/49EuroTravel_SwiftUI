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
		VStack{
			switch viewModel.resultJourneysCollectionViewDataSourse.awaitingData {
			case true:
				JourneyScrollViewLoader()
			case false:
				ScrollViewReader { proxy in
					ScrollView(showsIndicators: false)  {
						if viewModel.state == .onNewDataJourney{
							JourneyScrollViewHeader()
								.id(-1)
							ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { (journey) in
								VStack {
									JourneyHeaderView(journey: journey)
									LegsView(journey : journey)
									BadgesView(badges: [.cancelled,.dticket])
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
							JourneyScrollViewFooter()
						}
					}
				}
				
//				ObservableScrollView(scrollOffset: $viewModel.scrollOffset) { proxy in
//					if viewModel.state == .onNewDataJourney{
//						JourneyScrollViewHeader()
//							.id(-1)
//						ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { (journey) in
//							VStack {
//								JourneyHeaderView(journey: journey)
//								LegsView(journey : journey)
//								BadgesView(badges: [.init(color: UIColor(hue: 0.3, saturation: 1, brightness: 0.4, alpha: 1), name: "DeutschlandTicket")])
//							}
//							.id(journey.id)
//							.background(.ultraThinMaterial)
//							.cornerRadius(10)
//							.frame(maxWidth: .infinity)
//							.shadow(radius: 1,y:2)
//							.onAppear{
//								proxy.scrollTo(0,anchor: .top)
//							}
//						}
//						JourneyScrollViewFooter()
//					}
//				}
//				.onChange(of: viewModel.scrollOffset, perform: { offset in
//					if -offset > 100 {
//						viewModel.updateJourneyTimeValue(date: viewModel.timeChooserDate)
//					}
//				})
				.transition(.move(edge: .bottom))
				.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse)
			}
		}
		.transition(.move(edge: .bottom))
		.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse)
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}

