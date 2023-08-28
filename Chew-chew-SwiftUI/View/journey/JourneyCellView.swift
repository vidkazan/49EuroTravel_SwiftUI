//
//  JourneyView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

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
				longPressDate = Date()
				if isPressed {
					pressAction()
					doubleTapDate = tryTriggerDoubleTap() ? .distantPast : .now
					tryTriggerLongPressAfterDelay(triggered: longPressDate)
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
				ScrollView(showsIndicators: false) {
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
