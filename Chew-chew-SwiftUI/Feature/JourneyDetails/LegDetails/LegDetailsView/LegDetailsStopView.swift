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
	var time : Prognosed<String>
	var delay : TimeContainer.DelayStatus
	var cancelType : StopOverCancellationType
	let now = Date.now.timeIntervalSince1970
	let showBadges : Bool
	
	// MARK: Init
	init(
		type : StopOverType,
		vm : LegDetailsViewModel,
		stopOver : StopViewData,
		leg : LegViewData,
		showBadges : Bool = true
	) {
		self.showBadges = showBadges
		self.vm = vm
		self.stopOver = stopOver
		self.stopOverType = type
		self.legViewData = leg
		switch type {
		case .origin,.transfer, .footTop,.footMiddle:
			self.time = Prognosed(
				actual: stopOver.timeContainer.stringTimeValue.departure.actual ?? "",
				planned: stopOver.timeContainer.stringTimeValue.departure.planned ?? ""
			)
			self.delay = stopOver.timeContainer.departureStatus
			self.cancelType = (stopOver.timeContainer.departureStatus == TimeContainer.DelayStatus.cancelled) ? .fullyCancelled : .notCancelled
		case .stopover:
			self.time = Prognosed(
				actual: stopOver.timeContainer.stringTimeValue.departure.actual ?? "",
				planned: stopOver.timeContainer.stringTimeValue.departure.planned ?? ""
			)
			self.delay = stopOver.timeContainer.departureStatus
			self.cancelType = StopOverCancellationType.getCancelledTypeFromDelayStatus(
				arrivalStatus: stopOver.timeContainer.arrivalStatus,
				departureStatus: stopOver.timeContainer.departureStatus
			)
		case .destination, .footBottom:
			self.time = Prognosed(
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
							BadgeView(.transfer(duration: legViewData.duration))
						}
					}
					if case .footMiddle=stopOverType {
						HStack(spacing: 3) {
							BadgeView(
								.walking(duration: legViewData.duration)
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
						BadgeView(.walking(duration: legViewData.duration))
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
								Gradient.Stop(color: Color.chewFillGreenPrimary, location: 0),
								Gradient.Stop(color: Color.chewFillGreenPrimary, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
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
									Gradient.Stop(color: Color.chewFillGreenPrimary, location: 0),
									Gradient.Stop(color: Color.chewFillGreenPrimary, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: now) ?? 0),
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
							BadgeView(.walking(duration: legViewData.duration))
						}
					case .origin:
						PlatformView(
							isShowingPlatormWord: true,
							platform: stopOver.departurePlatform.actual,
							plannedPlatform: stopOver.departurePlatform.planned
						)
						if showBadges == true {
							HStack(spacing: 2) {
								BadgeView(.lineNumber(
									lineType:legViewData.lineViewData.type ,
									num: legViewData.lineViewData.name
								))
								BadgeView(.legDirection(dir: legViewData.direction))
									.badgeBackgroundStyle(.primary)
								BadgeView(.legDuration(dur: legViewData.duration))
									.badgeBackgroundStyle(.primary)
								BadgeView(.stopsCount(legViewData.legStopsViewData.count - 1,vm.state.status == .idle ? .showShevronUp: .showShevronDown))
									.badgeBackgroundStyle(.primary)
							}
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
							BadgeView(.transfer(duration: legViewData.duration))
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

struct LegDetailsStopPreview : PreviewProvider {
	static var previews : some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip,
			let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock]),
		   let stop = viewData.legStopsViewData.first {
			LegStopView(
				type: .origin,
				vm: .init(leg: viewData),
				stopOver: stop,
				leg: viewData,
				showBadges: false
			)
		} else {
			Text("error")
		}
	}
}
