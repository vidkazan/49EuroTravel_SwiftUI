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
		case origin(StopOver,Line?,Leg)
		case stopover(StopOver)
		case destination(StopOver)
		
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
	let stopType : StopOverType
	var plannedTS : String
	var actualTS : String
	
	init(type : StopOverType, vm : LegDetailsViewModel) {
		self.viewModel = vm
		self.stopType = type
		self.actualTS = {
			switch type {
			case .origin(let stopOver, (_), (_)):
				return stopOver.departure ?? "error"
			case .stopover(let stopOver):
				return stopOver.departure ?? "error"
			case .destination(let stopOver):
				return stopOver.arrival ?? "error"
			}
		}()
		self.plannedTS = {
			switch type {
			case .origin(let stopOver, (_),(_)):
				return stopOver.plannedDeparture ?? "error"
			case .stopover(let stopOver):
				return stopOver.plannedDeparture ?? "error"
			case .destination(let stopOver):
				return stopOver.plannedArrival ?? "error"
			}
		}()
	}
	var body : some View {
		HStack(alignment: .top) {
			TimeLabelView(
				isSmall: stopType.description == "stopover",
				arragement: .bottom,
				planned: DateParcer.getDateFromDateString(dateString: plannedTS) ?? .distantPast,
				actual: DateParcer.getDateFromDateString(dateString: actualTS) ?? .distantPast
			)
			.padding(3)
			.background(.thinMaterial)
			.cornerRadius(8)
			.frame(alignment: .leading)
			.padding(5)
			VStack(alignment: .leading, spacing: 2) {
				switch stopType {
				case .origin(let stopover, let line, let leg):
					Text((stopover.stop?.name) ?? "origin")
						.font(.system(size: 17,weight: .semibold))
				case .stopover(let stopover):
					Text((stopover.stop?.name) ?? "origin")
						.font(.system(size: 12,weight: .semibold))
				case .destination(let stopover):
					Text((stopover.stop?.name) ?? "origin")
						.font(.system(size: 17,weight: .semibold))
				}

				switch stopType {
				case .origin(let stopover, let line, let leg):
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopover.departurePlatform,
						plannedPlatform: stopover.plannedDeparturePlatform
					)
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
					.padding(.top,7)
				case  .destination(let stopover):
					PlatformView(
						isShowingPlatormWord: true,
						platform: stopover.departurePlatform,
						plannedPlatform: stopover.plannedDeparturePlatform
					)
				case .stopover(let stopOver):
					EmptyView()
				}
			}
			.padding(3)
			Spacer()
		}
	}
}
