//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	@ObservedObject var vm : LegDetailsViewModel
	let legViewData : LegViewData
	let stopOver : LegViewData.StopViewData
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	var delay : Int
	let now = Date.now.timeIntervalSince1970
	init(type : StopOverType, vm : LegDetailsViewModel,stopOver : LegViewData.StopViewData,leg : LegViewData) {
		self.vm = vm
		self.stopOver = stopOver
		self.stopType = type
		self.legViewData = leg
		switch type {
		case .origin,.stopover,.transfer, .footTop,.footMiddle:
			self.actualTS = stopOver.departureActualTimeString
			self.plannedTS = stopOver.departurePlannedTimeString
			self.delay = stopOver.departureDelay
		case .destination, .footBottom:
			self.actualTS = stopOver.arrivalActualTimeString
			self.plannedTS = stopOver.arrivalPlannedTimeString
			self.delay = stopOver.arrivalDelay
		}
	}
	var body : some View {
		switch stopType {
		case .transfer,.footMiddle:
			HStack(alignment:  .center) {
				VStack(alignment: .leading) {
					Rectangle()
						.fill(.clear)
				}
				.frame(width: 70)
				VStack(alignment: .leading) {
					if case .transfer=stopType {
						HStack(spacing: 3) {
							BadgeView(badge: .transfer(duration: legViewData.duration))
						}
					}
					if case .footMiddle=stopType {
						HStack(spacing: 3) {
							BadgeView(badge: .walking(duration: legViewData.duration))
						}
					}
				}
				Spacer()
			}
			.frame(height: stopType.viewHeight)
		default:
			HStack(alignment:  .top) {
				// MARK: Time Label
				VStack(alignment: .leading) {
					switch stopType {
					case .stopover:
						TimeLabelView(
							isSmall: true,arragement: .right,planned: plannedTS,actual: actualTS,delay: delay)
						.frame(height: stopType.timeLabelHeight)
						.background {
							LinearGradient(stops: [
								.init(color: .chewGrayScale10, location: 0),
								.init(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
								.init(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
							], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
						}
						.cornerRadius(7)
					case .origin,.destination:
						TimeLabelView(isSmall: false,arragement: .bottom,planned: plannedTS,actual: actualTS,delay: delay)
						.background {
							LinearGradient(stops: [
								.init(color: .chewGrayScale10, location: 0),
								.init(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
								.init(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
							], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
						}
						.cornerRadius(10)
					case .footTop,.footBottom:
						TimeLabelView(isSmall: false,arragement: .bottom,planned: plannedTS,actual: actualTS,delay: delay)
							.background(Color.chewGrayScale10)
						.cornerRadius(10)
					case .footMiddle,.transfer:
						Rectangle()
							.fill(.clear)
					}
					Spacer()
				}
				.frame(width: 70)
				VStack(alignment: .leading, spacing: 2) {
					// MARK: Location Name above Badges
					switch stopType {
					case .origin, .destination,.footTop:
						Text(stopOver.name)
							.font(.system(size: 17,weight: .semibold))
					case .stopover:
						Text(stopOver.name)
							.font(.system(size: 12,weight: .semibold))
							.foregroundColor(.gray)
					case .transfer,.footBottom,.footMiddle:
						EmptyView()
					}
					// MARK: Badges
					
					switch stopType {
					case .footBottom,.footMiddle,.footTop:
						HStack(spacing: 3) {
							BadgeView(badge: .walking(duration: legViewData.duration))
						}
					case .origin:
						PlatformView(
							isShowingPlatormWord: true,
							platform: stopOver.departurePlatform,
							plannedPlatform: stopOver.plannedDeparturePlatform
						)
						HStack(spacing: 3) {
							BadgeView(badge: .lineNumber(lineType:.other(type: "mode") ,num: legViewData.lineName))
							BadgeView(badge: .legDirection(dir: legViewData.direction))
							BadgeView(badge: .legDuration(dur: legViewData.duration))
							HStack(spacing: 0) {
								BadgeView(badge: .stopsCount(legViewData.legStopsViewData.count - 1))
								if legViewData.legStopsViewData.count > 2 {
									Image(systemName: "chevron.down.circle")
										.font(.system(size: 15,weight: .semibold))
										.rotationEffect(vm.state.status == .idle ? .degrees(0) : .degrees(180))
										.animation(.spring(), value: vm.state.status)
								}
							}
							.background(Color.chewGray10)
							.cornerRadius(8)
						}
					case  .destination:
						PlatformView(
							isShowingPlatormWord: true,
							platform: stopOver.arrivalPlatform,
							plannedPlatform: stopOver.plannedArrivalPlatform
						)
					case .stopover:
						EmptyView()
					case .transfer:
						HStack(spacing: 3) {
							BadgeView(badge: .transfer(duration: legViewData.duration))
						}
					}
					// MARK: Location Name under Badges
					
					if case .footBottom = stopType{
						Text(stopOver.name)
							.font(.system(size: 17,weight: .semibold))
					}
				}
				Spacer()
			}
			.frame(height: stopType.viewHeight)
		}
	}
}

enum StopOverType : Equatable {
	case origin
	case stopover
	case destination
	case footTop
	case footMiddle
	case footBottom
	case transfer
	
	var timeLabelHeight : CGFloat {
		switch self {
		case .destination,.origin:
			return 30
		case .transfer,.footMiddle,.footBottom,.footTop,.stopover:
			return 15
		}
	}
	
	var viewHeight : CGFloat {
		switch self {
		case .destination:
			return 50
		case .origin:
			return 90
		case .stopover:
			return 35
		case .transfer,.footMiddle,.footBottom,.footTop:
			return 70
		}
	}
	
	var description : String {
		switch self {
		case .destination:
			return "destination"
		case .origin:
			return "origin"
		case .stopover:
			return "stopover"
		case .transfer:
			return "transfer"
		case .footMiddle:
			return "footMiddle"
		case .footBottom:
			return "footBottom"
		case .footTop:
			return "footTop"
		}
	}
}
