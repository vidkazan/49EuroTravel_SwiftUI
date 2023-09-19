//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView: View {
	@ObservedObject var viewModel : LegDetailsViewModel
	let line : Line?
	let type : LocationDirectionType
	let stopover : StopOver?
	let plannedTS : String
	let actualTS : String

	init(viewModel: LegDetailsViewModel, line: Line?, type: LocationDirectionType, stopover: StopOver?) {
		self.viewModel = viewModel
		self.line = line
		self.type = type
		self.stopover = stopover
		
		self.actualTS = {
			switch stopover {
			case .none:
				return type == .departure ? viewModel.state.leg.departure ?? "" : viewModel.state.leg.arrival ?? ""
			case .some(let wrapped):
				return type == .departure ? wrapped.departure ?? "" : wrapped.arrival ?? ""
			}
		}()
		self.plannedTS = {
			switch stopover {
			case .none:
				return type == .departure ? viewModel.state.leg.plannedDeparture ?? "" : viewModel.state.leg.plannedArrival ?? ""
			case .some(let wrapped):
				return type == .departure ? wrapped.plannedDeparture ?? "" : wrapped.plannedArrival ?? ""
			}
		}()
	}
	
	var body : some View {
		HStack(alignment: .top) {
			TimeLabelView(
				isSmall: stopover != nil,
				isLeft: false,
				planned: DateParcer.getDateFromDateString(dateString: plannedTS) ?? .distantPast,
				actual: DateParcer.getDateFromDateString(dateString: actualTS) ?? .distantPast
			)
				.padding(3)
				.background(.thinMaterial)
				.cornerRadius(8)
				.frame(minWidth: 85,alignment: .leading)
				.padding(5)
			VStack(alignment: .leading, spacing: 2) {
				if let stopover = stopover {
					Text((stopover.stop?.name) ?? "origin")
						.font(.system(size: 12,weight: .semibold))
				} else {
					Text((type == .arrival ? viewModel.state.leg.destination?.name : viewModel.state.leg.origin?.name) ?? "origin")
						.font(.system(size: 17,weight: .semibold))
				}
				if stopover == nil {
					PlatformView(
						isShowingPlatormWord: true,
						platform: type == .departure ? viewModel.state.leg.plannedDeparturePlatform : viewModel.state.leg.plannedArrivalPlatform,
						plannedPlatform: type == .departure ? viewModel.state.leg.departurePlatform : viewModel.state.leg.arrivalPlatform
					)
				}
				if let line = line {
					HStack(spacing: 3) {
						BadgeView(badge: .lineNumber(num: line.name ?? "line"))
						BadgeView(badge: .legDirection(dir:viewModel.state.leg.direction ?? "Direction"))
						BadgeView(badge: .legDuration(
							dur: DateParcer.getTwoDateIntervalInMinutes(
								date1: DateParcer.getDateFromDateString(dateString:viewModel.state.leg.departure),
								date2: DateParcer.getDateFromDateString(dateString:viewModel.state.leg.arrival)
							) ?? 0)
						)
						Button(action: {
							viewModel.send(event: .didtapExpandButton)
						}, label: {
							Image(systemName: "chevron.down")
								.font(.system(size: 12,weight: .semibold))
								.foregroundColor(.gray)
								.padding(7)
								.background(.ultraThinMaterial)
								.cornerRadius(10)
						})
					}
					.padding(.top,7)
				}
			}
			.padding(3)
			Spacer()
		}
	}
}

