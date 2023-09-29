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
		case footTop
		case footMiddle
		case footBottom
		case transfer
		
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
	@ObservedObject var vm : LegDetailsViewModel
	let legViewData : LegViewData
	let stopOver : LegViewData.StopViewData
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	var delay : Int
	
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
		HStack(alignment:  .top) {
			
			// MARK: Time Label
			VStack {
				switch stopType {
				case .stopover:
					Spacer()
					TimeLabelView(
						isSmall: true,
						arragement: .bottom,
						planned: plannedTS,
						actual: actualTS,
						delay: delay
					)
					.padding(3)
					.background(Color.chewGray10)
					.cornerRadius(7)
					.frame(width: 60,alignment: .center)
					Spacer()
				case .origin,.destination,.footTop,.footBottom:
					TimeLabelView(
						isSmall: false,
						arragement: .bottom,
						planned: plannedTS,
						actual: actualTS,
						delay: delay
					)
					.padding(3)
					.background(Color.chewGray10)
					.cornerRadius(10)
					.frame(width: 60,alignment: .center)
				case .footMiddle:
					Rectangle()
						.fill(.clear)
						.padding(3)
						.frame(width: 60,alignment: .center)
				case .transfer:
					Rectangle()
						.fill(.clear)
						.padding(3)
						.frame(width: 60,alignment: .center)
				}
			}
			VStack(alignment: .leading, spacing: 2) {
				
				// MARK: Location Name above Badges
				
				switch stopType {
				case .origin, .destination:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				case .stopover:
					Spacer()
					Text(stopOver.name)
						.font(.system(size: 12,weight: .semibold))
						.foregroundColor(.gray)
						.frame(height: 15,alignment: .center)
					Spacer()
				case .transfer,.footBottom,.footMiddle:
					EmptyView()
				case .footTop:
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				}
				
				// MARK: Badges
				
				switch stopType {
				case .footBottom,.footMiddle,.footTop:
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
//						BadgeView(badge: .legDuration(dur: legViewData.duration))
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
						BadgeView(badge: .transfer(duration: legViewData.duration))
					}
					.frame(height: 20)
				}
				
				// MARK: Location Name under Badges
				
				if case .footBottom = stopType{
					Text(stopOver.name)
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				}
			}
			Spacer()
		}
	}
}
