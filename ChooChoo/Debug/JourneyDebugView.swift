//
//  File.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 04.03.24.
//

import Foundation
import SwiftUI

struct StopWithTimeDebugView : View {
	let stopDTO : StopWithTimeDTO?
	var body: some View {
		VStack(alignment: .leading) {
			StopDebugView(stopDTO: stopDTO?.stop)
			TimeContainerDebugView(time: TimeContainer(
				plannedDeparture: stopDTO?.plannedDeparture,
				plannedArrival: stopDTO?.plannedArrival,
				actualDeparture: stopDTO?.departure,
				actualArrival: stopDTO?.arrival,
				cancelled: nil
			))
		}
	}
}


struct StopDebugView : View {
	let stopDTO : StopDTO?
	var body: some View {
		VStack(alignment: .leading, content: {
			Text(stopDTO?.name ?? "name")
				.chewTextSize(.big)
			Text(stopDTO?.type ?? "type")
				.chewTextSize(.medium)
			Text(stopDTO?.id ?? "id")
				.chewTextSize(.medium)
		})
		.padding(5)
	}
}

struct PrognosedDateDebugView : View {
	let date : Prognosed<Date>
	var body: some View {
		if let planned = date.planned, let actual = date.actual {
			HStack {
				VStack(alignment: .leading, content: {
					Text("planned")
						.foregroundStyle(.secondary)
						.chewTextSize(.medium)
					Text(planned, style: .date)
						.chewTextSize(.medium)
					Text(planned, style: .time)
						.chewTextSize(.big)
				})
				.padding(5)
				.badgeBackgroundStyle(.secondary)
				VStack(alignment: .leading, content: {
					Text("actual")
						.foregroundStyle(.secondary)
						.chewTextSize(.medium)
					Text(actual, style: .date)
						.chewTextSize(.medium)
					Text(actual, style: .time)
						.chewTextSize(.big)
				})
				.padding(5)
				.badgeBackgroundStyle(.secondary)
			}
		}
	}
}

struct DelayStatusDebugView : View {
	let delay : TimeContainer.DelayStatus
	var body: some View {
		VStack(alignment: .leading, content: {
			Text(delay.description)
				.chewTextSize(.medium)
		})
	}
}

struct LineDebugView : View {
	let line : LineDTO?
	var body: some View {
		HStack {
			Text(line?.name ?? "name")
				.chewTextSize(.big)
			Text(line?.type ?? "type")
				.chewTextSize(.medium)
			Text(line?.product ?? "product")
				.chewTextSize(.medium)
			Text(line?.mode ?? "mode")
				.chewTextSize(.medium)
		}
	}
}


struct TimeContainerDebugView : View {
	let time : TimeContainer
	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, content: {
				Text("departure")
					.padding(5)
					.foregroundStyle(.green)
					.chewTextSize(.medium)
				HStack {
					PrognosedDateDebugView(date: time.date.departure)
					DelayStatusDebugView(delay: time.departureStatus)
				}
			})
			.padding(5)
			.badgeBackgroundStyle(.secondary)
			VStack(alignment: .leading, content: {
				Text("arrival")
					.padding(5)
					.foregroundStyle(.orange)
					.chewTextSize(.medium)
				HStack {
					PrognosedDateDebugView(date: time.date.arrival)
					DelayStatusDebugView(delay: time.arrivalStatus)
				}
			})
			.padding(5)
			.badgeBackgroundStyle(.secondary)
		}
	}
}


struct LegDebugView : View {
	let legDTO : LegDTO
	var body: some View {
		VStack(alignment: .leading) {
			Section {
				LineDebugView(line: legDTO.line)
			}
			.padding(5)
			.badgeBackgroundStyle(.secondary)
			Section("", content: {
				HStack {
					StopDebugView(stopDTO: legDTO.origin)
					StopDebugView(stopDTO: legDTO.destination)
				}
			})
			.badgeBackgroundStyle(.secondary)
			Section {
				TimeContainerDebugView(time: TimeContainer(
					plannedDeparture: legDTO.plannedDeparture,
					plannedArrival: legDTO.plannedArrival,
					actualDeparture: legDTO.departure,
					actualArrival: legDTO.arrival,
					cancelled: nil
				))
			}
			Section {
				if let stopovers = legDTO.stopovers {
					ScrollView {
						LazyVStack(alignment: .leading) {
							ForEach(stopovers, id: \.id, content: { stop in
								DisclosureGroup(
									content: {
										StopWithTimeDebugView(stopDTO: stop)
									},
									label: {
										Text(stop.stop?.name ?? "")
											.foregroundStyle(.primary)
											.foregroundColor(.primary)
											.chewTextSize(.medium)
									}
								)
								.padding(5)
								.badgeBackgroundStyle(.secondary)
							})
						}
					}
				}
			}
			.frame(maxHeight: 300)
			.padding(10)
			.badgeBackgroundStyle(.secondary)
		}
	}
}

struct JourneyDebugView : View {
	let legsDTO : [LegDTO]
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading) {
				ForEach(legsDTO, content: { leg in
					DisclosureGroup(
						content: {
							VStack {
								LegDebugView(legDTO: leg)
							}
								.padding(10)
						},
						label: {
								if let distance = leg.distance {
									BadgeView(.lineNumber(
										lineType: .foot,
										num: String(distance)
									))
								} else {
									BadgeView(.lineNumber(
										lineType: LineType(rawValue: leg.line?.product ?? "") ?? .taxi,
										num: leg.line?.name ?? ""
									))
								}
						}
					)
					.padding(10)
					.badgeBackgroundStyle(.secondary)
					.padding(.horizontal,10)
				})
			}
		}
	}
}


struct MapDetails_Previews: PreviewProvider {
	static var previews: some View {
		if let mock = Mock
			.journeys
			.journeyNeussWolfsburg
			.decodedData?.journey.legs {
			JourneyDebugView(legsDTO: mock)
		}
	}
}
