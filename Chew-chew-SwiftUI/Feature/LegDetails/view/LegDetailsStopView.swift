//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	@ObservedObject var viewModel : LegDetailsViewModel
	enum StopOverType : Equatable {
		case origin(Line?,Leg)
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
	let stopOver : StopOver
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	
	init(type : StopOverType, vm : LegDetailsViewModel,stopOver : StopOver) {
		self.stopOver = stopOver
		self.viewModel = vm
		self.stopType = type
		self.actualTS = {
			switch type {
			case .origin:
				return stopOver.departure ?? "error"
			case .stopover:
				return stopOver.departure ?? "error"
			case .destination:
				return stopOver.arrival ?? "error"
			}
		}()
		self.plannedTS = {
			switch type {
			case .origin:
				return stopOver.plannedDeparture ?? "error"
			case .stopover:
				return stopOver.plannedDeparture ?? "error"
			case .destination:
				return stopOver.plannedArrival ?? "error"
			}
		}()
	}
	var body : some View {
		HStack(alignment: .top) {
			TimeLabelView(
				isSmall: stopType == .stopover,
				arragement: .bottom,
				planned: DateParcer.getDateFromDateString(dateString: plannedTS) ?? .distantPast,
				actual: DateParcer.getDateFromDateString(dateString: actualTS) ?? .distantPast
			)
			.padding(stopType == .stopover ? 1 : 3)
			.background(.ultraThinMaterial)
			.cornerRadius(stopType == .stopover ? 5 : 10 )
			.frame(width: 60,alignment: .center)
			
			VStack(alignment: .leading, spacing: 2) {
				switch stopType {
				case .origin:
					Text((stopOver.stop?.name) ?? "origin")
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				case .stopover:
					Text((stopOver.stop?.name) ?? "origin")
						.font(.system(size: 12,weight: .semibold))
						.frame(height: 15,alignment: .center)
				case .destination:
					Text((stopOver.stop?.name) ?? "origin")
						.font(.system(size: 17,weight: .semibold))
						.frame(height: 20,alignment: .center)
				}
				
				switch stopType {
				case .origin(let line, let leg):
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopOver.departurePlatform,
						plannedPlatform: stopOver.plannedDeparturePlatform
					)
					.frame(height: 20)
					HStack(spacing: 3) {
						BadgeView(badge: .lineNumber(num: line?.name ?? "line"))
						BadgeView(badge: .legDirection(dir:leg.direction ?? "Direction"))
						BadgeView(badge: .legDuration(
							dur: DateParcer.getTwoDateIntervalInMinutes(
								date1: DateParcer.getDateFromDateString(dateString:leg.departure),
								date2: DateParcer.getDateFromDateString(dateString:leg.arrival)
							) ?? 0)
						)
						Button(action: {
							viewModel.send(event: .didtapExpandButton)
						}, label: {
							Image(systemName: viewModel.state.status == .idle ? "chevron.down" : "chevron.up")
								.font(.system(size: 12,weight: .semibold))
								.foregroundColor(.gray)
								.padding(7)
								.background(.ultraThinMaterial)
								.cornerRadius(10)
								.animation(.easeInOut, value: viewModel.state.status)
						})
					}
					.frame(height: 30)
				case  .destination:
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopOver.departurePlatform,
						plannedPlatform: stopOver.plannedDeparturePlatform
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
