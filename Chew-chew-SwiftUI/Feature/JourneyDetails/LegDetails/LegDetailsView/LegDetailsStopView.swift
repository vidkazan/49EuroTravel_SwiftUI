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
	let stopOver : StopViewData
	let stopOverType : StopOverType
	var time : PrognoseType<String>
	var delay : TimeContainer.Status
	let now = Date.now.timeIntervalSince1970
	// MARK: Init
	init(type : StopOverType, vm : LegDetailsViewModel,stopOver : StopViewData,leg : LegViewData) {
		self.vm = vm
		self.stopOver = stopOver
		self.stopOverType = type
		self.legViewData = leg
		switch type {
		case .origin,.stopover,.transfer, .footTop,.footMiddle:
			self.time = PrognoseType(actual: stopOver.timeContainer.stringTimeValue.departure.actual ?? "", planned: stopOver.timeContainer.stringTimeValue.departure.planned ?? "")
			self.delay = stopOver.timeContainer.departureDelay
		case .destination, .footBottom:
			self.time = PrognoseType(actual: stopOver.timeContainer.stringTimeValue.arrival.actual ?? "", planned: stopOver.timeContainer.stringTimeValue.arrival.planned ?? "")
			self.delay = stopOver.timeContainer.arrivalDelay
		}
	}
	var body : some View {
		switch stopOverType {
					// MARK: .transfer,.footMiddle
		case .transfer,.footMiddle:
			HStack(alignment:  .center) {
				VStack(alignment: .leading) {
					Rectangle()
						.fill(.clear)
				}
				.frame(width: 70)
				VStack(alignment: .leading) {
					if case .transfer=stopOverType {
						HStack(spacing: 3) {
							BadgeView(badge: .transfer(duration: legViewData.duration))
						}
					}
					if case .footMiddle=stopOverType {
						HStack(spacing: 3) {
							BadgeView(badge: .walking(duration: legViewData.duration))
						}
					}
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
					// MARK: .footBottom
		case .footBottom:
			HStack(alignment:  .bottom) {
				VStack(alignment: .leading) {
					Spacer()
					TimeLabelView(isSmall: false,arragement: .bottom,time: time,delay: delay)
						.background(Color.chewGrayScale10)
						.cornerRadius(10)
				}
				.frame(width: 70)
						// MARK: badges
				VStack(alignment: .leading, spacing: 2) {
					HStack(spacing: 3) {
						BadgeView(badge: .walking(duration: legViewData.duration))
					}
					Text(stopOver.name)
						.chewTextSize(.big)
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
					// MARK: default
		case .footTop,.origin,.destination,.stopover:
			HStack(alignment:  .top) {
				VStack(alignment: .leading) {
						// MARK: timeLabel
					switch stopOverType {
					case .stopover:
						TimeLabelView(
							isSmall: true,arragement: .right,time: time,delay: delay)
						.frame(height: stopOverType.timeLabelHeight)
						.background {
							LinearGradient(stops: [
								Gradient.Stop(color: .chewGrayScale10, location: 0),
								Gradient.Stop(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
								Gradient.Stop(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
							], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
						}
						.cornerRadius(7)
						.offset(x: delay.value != nil ? delay.value! > 0 ? 8 : 0 : 0)
					case .origin,.destination:
						TimeLabelView(isSmall: false,arragement: .bottom,time: time,delay: delay)
							.background {
								LinearGradient(stops: [
									Gradient.Stop(color: .chewGrayScale10, location: 0),
									Gradient.Stop(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
									Gradient.Stop(color: .chewGrayScale10, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
								], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
							}
							.cornerRadius(10)
					case .footTop:
						TimeLabelView(isSmall: false,arragement: .bottom,time: time,delay: delay)
							.background(Color.chewGrayScale10)
							.cornerRadius(10)
					case .footMiddle,.transfer,.footBottom:
						EmptyView()
					}
					Spacer()
				}
				.frame(width: 70)
				VStack(alignment: .leading, spacing: 2) {
					// MARK: stopName sup Badges
					switch stopOverType {
					case .origin, .destination,.footTop:
						Text(stopOver.name)
							.chewTextSize(.big)
					case .stopover:
						Text(stopOver.name)
							.chewTextSize(.medium)
							.foregroundColor(.gray)
					case .transfer,.footBottom,.footMiddle:
						EmptyView()
					}
							// MARK: badges
					switch stopOverType {
					case .footBottom,.footMiddle,.footTop:
						HStack(spacing: 3) {
							BadgeView(badge: .walking(duration: legViewData.duration))
						}
					case .origin:
						PlatformView(
							isShowingPlatormWord: true,
							platform: stopOver.departurePlatform.actual,
							plannedPlatform: stopOver.departurePlatform.planned
						)
						HStack(spacing: 3) {
							BadgeView(badge: .lineNumber(lineType:legViewData.lineViewData.type ,num: legViewData.lineViewData.name))
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
							platform: stopOver.arrivalPlatform.actual,
							plannedPlatform: stopOver.arrivalPlatform.planned
						)
					case .stopover:
						EmptyView()
					case .transfer:
						HStack(spacing: 3) {
							BadgeView(badge: .transfer(duration: legViewData.duration))
						}
					}
							// MARK: stopName sub Badges
					if case .footBottom = stopOverType{
						Text(stopOver.name)
							.chewTextSize(.big)
					}
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
		}
	}
}
