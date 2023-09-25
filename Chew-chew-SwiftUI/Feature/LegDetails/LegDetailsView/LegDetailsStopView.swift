//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	enum StopOverType : Equatable {
		case origin
		case stopover
		case destination
		case foot(FootLegPlace)
		case transfer
		
		var description : String {
			switch self {
			case .destination:
				return "destination"
			case .origin:
				return "origin"
			case .stopover:
				return "stopover"
			case .foot:
				return "foot"
			case .transfer:
				return "transfer"
			}
		}
	}
	let legViewData : LegViewData
	let stopOver : LegViewData.StopViewData
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	var delay : Int
	
	init(type : StopOverType, vm : LegDetailsViewModel,stopOver : LegViewData.StopViewData,leg : LegViewData) {
		self.stopOver = stopOver
		self.stopType = type
		self.legViewData = leg
		switch type {
		case .origin,.stopover,.transfer:
			self.actualTS = stopOver.departureActualTimeString
			self.plannedTS = stopOver.departurePlannedTimeString
			self.delay = stopOver.departureDelay
		case .destination:
			self.actualTS = stopOver.arrivalActualTimeString
			self.plannedTS = stopOver.arrivalPlannedTimeString
			self.delay = stopOver.arrivalDelay
		case .foot(let place):
			switch place {
			case .atStart, .inBetween:
				self.actualTS = stopOver.departureActualTimeString
				self.plannedTS = stopOver.departurePlannedTimeString
				self.delay = stopOver.departureDelay
			case .atFinish:
				self.actualTS = stopOver.arrivalActualTimeString
				self.plannedTS = stopOver.arrivalPlannedTimeString
				self.delay = stopOver.arrivalDelay
			}
		}
	}
	var body : some View {
		HStack(alignment:  .top) {
			// MARK: Time Label
			if case .foot(let place)=stopType, case .inBetween=place{
				Rectangle()
					.fill(.clear)
				.padding(3)
				.frame(width: 60,alignment: .center)
			} else {
				TimeLabelView(
					isSmall: stopType == .stopover,
					arragement: .bottom,
					planned: plannedTS,
					actual: actualTS,
					delay: delay
				)
				.padding(3)
				.background(.gray.opacity(0.15))
				.cornerRadius(stopType == .stopover ? 7 : 10 )
				.frame(width: 60,alignment: .center)
			}
			VStack(alignment: .leading, spacing: 2) {
				// MARK: Location Name above Badges
				switch stopType {
				case .origin, .destination:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				case .stopover:
					Text(stopOver.name)
						.font(.system(size: 12,weight: .semibold))
						.frame(height: 15,alignment: .center)
				case .foot(let place):
					switch place {
					case .inBetween:
						EmptyView()
					case .atFinish:
						EmptyView()
					case .atStart:
						Text(stopOver.name)
							.font(.system(size: 17,weight: .semibold))
							.frame(height: 20,alignment: .center)
					}
				case .transfer:
					EmptyView()
				}
				// MARK: Badges
				switch stopType {
				case .foot:
					HStack(spacing: 3) {
						BadgeView(badge: .walking(duration: legViewData.duration))
					}
					.frame(height: 30)
				case .origin:
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopOver.departurePlatform,
						plannedPlatform: stopOver.plannedDeparturePlatform
					)
					.frame(height: 20)
					HStack(spacing: 3) {
						BadgeView(badge: .lineNumber(lineType:.other(type: "mode") ,num: legViewData.lineName))
						BadgeView(badge: .legDirection(dir: legViewData.direction))
						BadgeView(badge: .legDuration(dur: legViewData.duration))
					}
					.frame(height: 30)
				case  .destination:
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopOver.arrivalPlatform,
						plannedPlatform: stopOver.plannedArrivalPlatform
					)
					.frame(height: 20)
				case .stopover:
					EmptyView()
				case .transfer:
					HStack(spacing: 3) {
						Text("transfer")
						BadgeView(badge: .legDuration(dur: legViewData.duration))
					}
					.frame(height: 30)
				}
				// MARK: Location Name under Badges
				if case .foot(let place)=stopType, case .atFinish=place{
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				}
			}
			Spacer()
		}
	}
}
