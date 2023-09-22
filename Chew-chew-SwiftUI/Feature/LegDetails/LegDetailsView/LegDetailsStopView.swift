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
//		case walk
//		case transfer
		
		var description : String {
			switch self {
			case .destination:
				return "destination"
			case .origin:
				return "origin"
			case .stopover:
				return "stopover"
//			case .walk:
//				return "walk"
//			case .transfer:
//				return "walk"
			}
		}
	}
	let stopOver : LegViewData.StopViewData
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	var delay : Int
	
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
//			case .walk:
//				return stopOver.departureActualTimeString
//			case .transfer:
//				return stopOver.departureActualTimeString
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
//			case .walk:
//				return stopOver.departureActualTimeString
//			case .transfer:
//				return stopOver.departureActualTimeString
			}
		}()
		self.delay = {
			switch type {
			case .origin:
				return stopOver.departureDelay
			case .stopover:
				return stopOver.departureDelay
			case .destination:
				return stopOver.arrivalDelay
			}
		}()
	}
	var body : some View {
		HStack(alignment: .top) {
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
			
			VStack(alignment: .leading, spacing: 2) {
				switch stopType {
				case .origin, .destination:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				case .stopover:
					Text(stopOver.name)
						.font(.system(size: 12,weight: .semibold))
						.frame(height: 15,alignment: .center)
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
						case .line(mode: let mode, name: let name):
							BadgeView(badge: .lineNumber(lineType:.other(type: mode) ,num: name))
							BadgeView(badge: .legDirection(dir: legViewData.direction))
						case .foot(distance: let dist,_):
							BadgeView(badge: .walkingDistance(dist))
						case .transfer(duration: let duration):
							BadgeView(badge: .legDuration(dur: "\(duration)min"))
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
//				case .walk:
//					HStack(spacing: 3) {
//						BadgeView(badge: .walking(direction: "direction"))
//						BadgeView(badge: .walkingDistance(1100))
//					}
				}
			}
			Spacer()
		}
	}
}
