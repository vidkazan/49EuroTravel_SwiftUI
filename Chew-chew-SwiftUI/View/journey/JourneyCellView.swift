//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI



struct ScrollViewGestureButton<Label: View>: View {

	init(
		doubleTapTimeoutout: TimeInterval = 0.5,
		longPressTime: TimeInterval = 1,
		pressAction: @escaping () -> Void = {},
		releaseAction: @escaping () -> Void = {},
		endAction: @escaping () -> Void = {},
		longPressAction: @escaping () -> Void = {},
		doubleTapAction: @escaping () -> Void = {},
		label: @escaping () -> Label
	) {
		self.style = ScrollViewGestureButtonStyle(
			pressAction: pressAction,
			doubleTapTimeoutout: doubleTapTimeoutout,
			doubleTapAction: doubleTapAction,
			longPressTime: longPressTime,
			longPressAction: longPressAction,
			endAction: endAction
		)
		self.releaseAction = releaseAction
		self.label = label
	}

	var label: () -> Label
	var style: ScrollViewGestureButtonStyle
	var releaseAction: () -> Void

	var body: some View {
		Button(action: releaseAction, label: label)
			.buttonStyle(style)
	}
}

struct ScrollViewGestureButtonStyle: ButtonStyle {

	init(
		pressAction: @escaping () -> Void,
		doubleTapTimeoutout: TimeInterval,
		doubleTapAction: @escaping () -> Void,
		longPressTime: TimeInterval,
		longPressAction: @escaping () -> Void,
		endAction: @escaping () -> Void
	) {
		self.pressAction = pressAction
		self.doubleTapTimeoutout = doubleTapTimeoutout
		self.doubleTapAction = doubleTapAction
		self.longPressTime = longPressTime
		self.longPressAction = longPressAction
		self.endAction = endAction
	}

	private var doubleTapTimeoutout: TimeInterval
	private var longPressTime: TimeInterval

	private var pressAction: () -> Void
	private var longPressAction: () -> Void
	private var doubleTapAction: () -> Void
	private var endAction: () -> Void

	@State
	var doubleTapDate = Date()

	@State
	var longPressDate = Date()

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.onChange(of: configuration.isPressed) { isPressed in
//				longPressDate = Date()
				if isPressed {
					pressAction()
//					doubleTapDate = tryTriggerDoubleTap() ? .distantPast : .now
//					tryTriggerLongPressAfterDelay(triggered: longPressDate)?
				} else {
					endAction()
				}
			}
	}
}

private extension ScrollViewGestureButtonStyle {

	func tryTriggerDoubleTap() -> Bool {
		let interval = Date().timeIntervalSince(doubleTapDate)
		guard interval < doubleTapTimeoutout else { return false }
		doubleTapAction()
		return true
	}

	func tryTriggerLongPressAfterDelay(triggered date: Date) {
		DispatchQueue.main.asyncAfter(deadline: .now() + longPressTime) {
			guard date == longPressDate else { return }
			longPressAction()
		}
	}
}


struct JourneyCellView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
    var body: some View {
		VStack{
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
					ObservableScrollView(scrollOffset: $viewModel.scrollOffset) { proxy in
						if viewModel.state == .onNewDataJourney && viewModel.resultJourneysCollectionViewDataSourse.journeys.count > 0 {
							VStack {
								HStack{
									ZStack(alignment: .leading){
										Rectangle()
											.fill(.ultraThinMaterial.opacity(0.4))
											.cornerRadius(10)
											.frame(width: 80,alignment: .leading)
										Rectangle()
											.fill(Color(hue: 0.3, saturation: 1, brightness: 0.4))
											.cornerRadius(10)
											.frame(width: -viewModel.scrollOffset < 0 ? 0 : -viewModel.scrollOffset*8/15,alignment: .leading)
											.animation(.easeInOut, value: -viewModel.scrollOffset)
										Text("Reload")
											.frame(maxWidth: 80)
											.font(.system(size: 17, weight: .medium))
											.foregroundColor(.white)
											.padding(5)
									}
									.frame(maxWidth: 80)
									.cornerRadius(10)
									Spacer()
									ZStack(alignment: .leading){
										Rectangle()
											.fill(.ultraThinMaterial.opacity(0.4))
											.cornerRadius(10)
											.frame(width: 80,alignment: .leading)
										Text("Earlier")
											.frame(maxWidth: 80)
											.font(.system(size: 17, weight: .medium))
											.foregroundColor(.white)
											.padding(5)
									}
									.frame(maxWidth: 80)
									.cornerRadius(10)
								}
							}
							.id(-1)
							ForEach(viewModel.resultJourneysCollectionViewDataSourse.journeys) { (journey) in
								VStack {
									JourneyHeaderView(journey: journey)
									LegsView(journey : journey)
									BadgesView(badges: [.init(color: UIColor(hue: 0.3, saturation: 1, brightness: 0.4, alpha: 1), name: "DeutschlandTicket")])
								}
								.background(.ultraThinMaterial)
								.cornerRadius(10)
								.frame(maxWidth: .infinity)
								.shadow(radius: 1,y:2)
								.id(journey.id)
								.onAppear{
									proxy.scrollTo(0,anchor: .top)
								}
							}
							Button(action:{
								
							}, label:{
								HStack{
									Spacer()
									ZStack(alignment: .leading){
										Rectangle()
											.fill(.ultraThinMaterial.opacity(0.4))
											.cornerRadius(10)
											.frame(width: 80,alignment: .leading)
										Text("Later")
											.frame(maxWidth: 80)
											.font(.system(size: 17, weight: .medium))
											.foregroundColor(.white)
											.padding(5)
									}
									.frame(maxWidth: 80)
									.cornerRadius(10)
								}
							})
							
						}
					}
					.onChange(of: viewModel.scrollOffset, perform: { offset in
						if -offset > 150 {
							viewModel.updateJourneyTimeValue(date: viewModel.timeChooserDate)
						}
					})
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
        JourneyCellView()
    }
}

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

	init(scrollOffset: Binding<CGFloat>,offset: Int = 0,
	   @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
	_scrollOffset = scrollOffset
	self.content = content
  }

  var body: some View {
	ScrollView(showsIndicators: false) {
	  ScrollViewReader { proxy in
		  content(proxy)
		  .background(GeometryReader { geo in
			  let offsetY = -geo.frame(in: .named(scrollSpace)).minY
			  Color.clear
				.preference(key: ScrollViewOffsetPreferenceKey.self,
							value: offsetY)
		  })
	  }
	}
	.coordinateSpace(name: scrollSpace)
	.onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offsetY in
	  scrollOffset = offsetY
	}
  }
}
