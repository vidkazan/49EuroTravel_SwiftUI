//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	static let timeLabelColor = Color.chewTimeLabelGray
	@ObservedObject var vm : LegDetailsViewModel
	let legViewData : LegViewData
	let stopOver : StopViewData
	let stopOverType : StopOverType
	var time : PrognosedTime<String>
	var delay : TimeContainer.DelayStatus
	var cancelType : StopOverCancelledType
	let now = Date.now.timeIntervalSince1970
	// MARK: Init
	init(
		type : StopOverType,
		vm : LegDetailsViewModel,
		stopOver : StopViewData,
		leg : LegViewData
	) {
		self.vm = vm
		self.stopOver = stopOver
		self.stopOverType = type
		self.legViewData = leg
		switch type {
		case .origin,.transfer, .footTop,.footMiddle:
			self.time = PrognosedTime(
				actual: stopOver.timeContainer.stringTimeValue.departure.actual ?? "",
				planned: stopOver.timeContainer.stringTimeValue.departure.planned ?? ""
			)
			self.delay = stopOver.timeContainer.departureStatus
			self.cancelType = (stopOver.timeContainer.departureStatus == TimeContainer.DelayStatus.cancelled) ? .fullyCancelled : .notCancelled
		case .stopover:
			self.time = PrognosedTime(
				actual: stopOver.timeContainer.stringTimeValue.departure.actual ?? "",
				planned: stopOver.timeContainer.stringTimeValue.departure.planned ?? ""
			)
			self.delay = stopOver.timeContainer.departureStatus
			self.cancelType = StopOverCancelledType.getCancelledTypeFromDelayStatus(
				arrivalStatus: stopOver.timeContainer.arrivalStatus,
				departureStatus: stopOver.timeContainer.departureStatus
			)
		case .destination, .footBottom:
			self.time = PrognosedTime(
				actual: stopOver.timeContainer.stringTimeValue.arrival.actual ?? "",
				planned: stopOver.timeContainer.stringTimeValue.arrival.planned ?? ""
			)
			self.delay = stopOver.timeContainer.arrivalStatus
			self.cancelType = (stopOver.timeContainer.arrivalStatus == TimeContainer.DelayStatus.cancelled) ? .fullyCancelled : .notCancelled
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
							BadgeView(
								badge: .transfer(duration: legViewData.duration)
							)
						}
					}
					if case .footMiddle=stopOverType {
						HStack(spacing: 3) {
							BadgeView(
								badge: .walking(duration: legViewData.duration)
							)
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
					TimeLabelView(
						isSmall: false,
						arragement: .bottom,
						time: time,
						delay: delay.value,
						isCancelled: cancelType == .fullyCancelled
					)
					.background(Self.timeLabelColor)
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
							isSmall: true,
							arragement: .right,
							time: time,
							delay: delay.value,
							isCancelled: cancelType == .fullyCancelled
						)
						.frame(height: stopOverType.timeLabelHeight)
						.background {
							LinearGradient(stops: [
								Gradient.Stop(color: Self.timeLabelColor, location: 0),
								Gradient.Stop(color: Self.timeLabelColor, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
								Gradient.Stop(color: Self.timeLabelColor, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
							], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
						}
						.cornerRadius(7)
						.offset(x: delay.value != nil ? delay.value! > 0 ? 8 : 0 : 0)
					case .origin,.destination:
						TimeLabelView(
							isSmall: false,
							arragement: .bottom,
							time: time,
							delay: delay.value,
							isCancelled: cancelType == .fullyCancelled
						)
							.background {
								LinearGradient(stops: [
									Gradient.Stop(color: Self.timeLabelColor, location: 0),
									Gradient.Stop(color: Self.timeLabelColor, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
									Gradient.Stop(color: Self.timeLabelColor, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0)
								], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
							}
							.cornerRadius(10)
					case .footTop:
						TimeLabelView(
							isSmall: false,
							arragement: .bottom,
							time: time,
							delay: delay.value,
							isCancelled: cancelType == .fullyCancelled
						)
							.background(Self.timeLabelColor)
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
							.background(Color.chewFillPrimary)
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
