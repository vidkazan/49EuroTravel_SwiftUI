//
//  Tips.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 08.03.24.
//

import Foundation
import TipKit
import SwiftUI

@available(iOS 17, *)
struct ChooTips {
	static let followJourney = ChooTipFollowJourney()
	static let searchNowButtonTip = ChooTipNowButton()
	static let searchTip = ChooTipSearch()
}

@available(iOS 17, *)
struct ChooTipSearch : Tip {
	var title: Text {
		Text("Search")
	}
	var message: Text? {
		Text(
			"This app doent have search button. Search starts when you set both departure and arrival stops."
		)
	}
	var image: Image? {
		Image(systemName: ChewSFSymbols.trainSideFrontCar.rawValue)
	}
}

@available(iOS 17, *)
struct ChooTipNowButton : Tip {
	var title: Text {
		Text("Search update")
	}
	var message: Text? {
		Text("If you want to update your search, simply press here")
	}
	var image: Image? {
		Image(systemName: "hand.tap")
	}
}

@available(iOS 17, *)
struct ChooTipFollowJourney : Tip {
	var title: Text {
		Text("Follow journey")
	}
	var message: Text? {
		Text("Your followed journeys always appear on follow page.")
	}
	var image: Image? {
		Image(systemName: ChewSFSymbols.bookmark.rawValue)
	}
}

struct HowToFollowJourneyView : View {
	@State var isPressed : Bool = false
	let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
	var body: some View {
		HStack {
			Spacer()
			Text("Journey Details")
				.chewTextSize(.big)
			Spacer()
			Group {
				Image(systemName: "bookmark")
					.symbolVariant(isPressed ? .fill : .none )
				Image(.arrowClockwise)
			}
			.foregroundStyle(.blue)
			.frame(width: 15,height: 15)
			.padding(5)
		}
		.onReceive(timer, perform: { _ in
			withAnimation {
				isPressed.toggle()
			}
		})
		.padding(10)
		.background(.regularMaterial)
		.clipShape(.rect(cornerRadius: 10, style: .continuous))
		.padding(10)
	}
}
