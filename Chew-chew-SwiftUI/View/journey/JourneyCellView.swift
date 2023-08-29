//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct JourneyCellView: View {
	@State var scrollOffset = CGFloat.zero
	@EnvironmentObject var viewModel : SearchLocationViewModel
    var body: some View {
		VStack{
			Text("\(scrollOffset)")
			switch viewModel.resultJourneysCollectionViewDataSourse.awaitingData {
			case true:
				VStack{
					Spacer()
					ProgressView()
						.progressViewStyle(.circular)
						.tint(.white)
					Spacer()
				}
				.transition(.identity)
				.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse)
			case false:
				ObservableScrollView(scrollOffset: $scrollOffset) { _ in
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
				.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse).ignoresSafeArea(.all)
			}
		}
		.transition(.move(edge: .bottom))
		.animation(.interactiveSpring(), value: viewModel.resultJourneysCollectionViewDataSourse).ignoresSafeArea(.all)
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyCellView()
    }
}


// Simple preference that observes a CGFloat.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
	value += nextValue()
  }
}

// A ScrollView wrapper that tracks scroll offset changes.
struct ObservableScrollView<Content>: View where Content : View {
  @Namespace var scrollSpace

  @Binding var scrollOffset: CGFloat
  let content: (ScrollViewProxy) -> Content

  init(scrollOffset: Binding<CGFloat>,
	   @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
	_scrollOffset = scrollOffset
	self.content = content
  }

  var body: some View {
	ScrollView(showsIndicators: false) {
	  ScrollViewReader { proxy in
		content(proxy)
		  .background(GeometryReader { geo in
			  let offset = -geo.frame(in: .named(scrollSpace)).minY
			  Color.clear
				.preference(key: ScrollViewOffsetPreferenceKey.self,
							value: offset)
		  })
	  }
	}
	.coordinateSpace(name: scrollSpace)
	.onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
	  scrollOffset = value
	}
  }
}
