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
		case origin(LegViewData)
		case stopover
		case destination
		
		var description : String {
			switch self {
			case .destination:
				return "destination"
			case .origin:
				return "origin"
			case .stopover:
				return "stopover"
			}
		}
	}
	let stopOver : LegViewData.StopViewData
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	
	init(type : StopOverType, vm : LegDetailsViewModel,stopOver : LegViewData.StopViewData) {
		self.stopOver = stopOver
		self.stopType = type
		self.actualTS = {
			switch type {
			case .origin:
				return stopOver.departureActualTimeString
			case .stopover:
				return stopOver.departureActualTimeString
			case .destination:
				return stopOver.arrivalActualTimeString
			}
		}()
		self.plannedTS = {
			switch type {
			case .origin:
				return stopOver.departurePlannedTimeString
			case .stopover:
				return stopOver.departurePlannedTimeString
			case .destination:
				return stopOver.arrivalPlannedTimeString
			}
		}()
	}
	var body : some View {
		HStack(alignment: .top) {
			TimeLabelView(
				isSmall: stopType == .stopover,
				arragement: .bottom,
				planned: plannedTS,
				actual: actualTS
			)
			.padding(3)
			.background(.gray.opacity(0.15))
			.cornerRadius(stopType == .stopover ? 7 : 10 )
			.frame(width: 60,alignment: .center)
			
			VStack(alignment: .leading, spacing: 2) {
				switch stopType {
				case .origin:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				case .stopover:
					Text(stopOver.name)
						.font(.system(size: 12,weight: .semibold))
						.frame(height: 15,alignment: .center)
				case .destination:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				}
				
				switch stopType {
				case .origin(let legViewData):
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopOver.departurePlatform,
						plannedPlatform: stopOver.plannedDeparturePlatform
					)
					.frame(height: 20)
					HStack(spacing: 3) {
						switch legViewData.legType {
						case .bus(name: let name), .train(name: let name):
							BadgeView(badge: .lineNumber(num: name))
							BadgeView(badge: .legDirection(dir: legViewData.direction))
						case .foot(distance: let dist):
							BadgeView(badge: .walkingDistance(dist))
						case .custom(name: let name):
							BadgeView(badge: .lineNumber(num: String(name)))
						}
						BadgeView(badge: .legDuration(dur: legViewData.duration)
						)
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
				}
			}
			Spacer()
		}
	}
}
