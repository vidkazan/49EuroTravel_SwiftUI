//
//  FullLegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.10.23.
//

import Foundation
import SwiftUI

// MARK: FullLegSheet
struct FullLegSheet: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyViewModel : JourneyDetailsViewModel
	@State var totalProgressHeight : Double = 0
	@State var currentProgressHeight : Double = 0
	let closeSheet : ()->Void
	
	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 0) {
				// MARK: FullLegView call
				switch journeyViewModel.state.status {
				case .loadingFullLeg:
					Spacer()
					ProgressView()
					Spacer()
				case .fullLeg(leg: let leg):
					LegDetailsView(
						send: { event in journeyViewModel.send(event: event)},
						referenceDate: chewVM.referenceDate,
						openSheet: { _,_  in },
						isExpanded: .expanded,
						leg: leg
					)
//					FullLegView(leg: leg, journeyDetailsViewModel: viewModel)
				default:
					EmptyView()
				}
				Spacer()
			}
			.chewTextSize(.big)
			.frame(maxWidth: .infinity)
			.background(Color.chewFillAccent)
			.navigationTitle("Full leg")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						closeSheet()
					}
				})
			}
		}
	}
}

//
//// MARK: FullLegView
//struct FullLegView: View {
//	@EnvironmentObject var chewVM : ChewViewModel
////	@ObservedObject var vm : LegDetailsViewModel
//	let leg : LegViewData
//	weak var journeyVM : JourneyDetailsViewModel?
//	init(leg : LegViewData,journeyDetailsViewModel: JourneyDetailsViewModel?) {
////		self.vm = LegDetailsViewModel(leg: leg,isExpanded: true)
//		self.journeyVM = journeyDetailsViewModel
//		self.leg = leg
//	}
//	var body : some View {
//		LegDetailsView(
//			send: journeyVM?.send,
//			referenceDate: ,
//			openSheet: <#T##(JourneyDetailsView.SheetType, LegViewData) -> Void#>,
//			isExpanded:.expanded,
//			leg: <#T##LegViewData#>
//		)
//			VStack(alignment: .center) {
//			//			 MARK: Header cell
//			VStack {
//				HStack(alignment: .bottom){
//					BadgeView(
//						.lineNumber(
//							lineType:leg.lineViewData.type ,
//							num: leg.lineViewData.name),
//						.big
//					)
//					Spacer()
//				}
//				HStack(alignment: .bottom){
//					BadgeView(.departureArrivalStops(
//						departure: leg.legStopsViewData.first?.name ?? "",
//						arrival: leg.legStopsViewData.last?.name ?? ""
//					),.big)
//					.badgeBackgroundStyle(.primary)
//					Spacer()
//				}
//				HStack {
//					BadgeView(.date(dateString: leg.time.stringDateValue.departure.actual ?? ""))
//						.badgeBackgroundStyle(.secondary)
//					BadgeView(
//						.timeDepartureTimeArrival(
//							timeDeparture: leg.time.stringTimeValue.departure.actual ?? "",
//							timeArrival: leg.time.stringTimeValue.arrival.actual ?? ""
//						)
//					)
//					.badgeBackgroundStyle(.secondary)
//					BadgeView(.legDuration(dur: leg.duration))
//						.badgeBackgroundStyle(.secondary)
//					BadgeView(.stopsCount(leg.legStopsViewData.count - 1,.hideShevron))
//						.badgeBackgroundStyle(.secondary)
//					Spacer()
//				}
//			}
//			.padding(5)
//			ScrollView {
//				LazyVStack(spacing: 0) {
//					switch leg.legType {
//					case .line:
//						// MARK: Leg top stop
//						if let stop = leg.legStopsViewData.first {
//							LegStopView(
//								type: stop.stopOverType,
//								stopOver: stop,
//								leg: leg,
//								showBadges: false,
//								shevronIsExpanded: .expanded
//							)
//						}
//						// MARK: Leg midlle stops
//						if case .stopovers = vm.state.status {
//							ForEach(leg.legStopsViewData) { stop in
//								if stop != leg.legStopsViewData.first,stop != leg.legStopsViewData.last {
//									LegStopView(
//										type: stop.stopOverType,
//										stopOver: stop,
//										leg: leg,
//										showBadges: false,
//										shevronIsExpanded: .expanded
//									)
//								}
//							}
//						}
//						// MARK: Leg bottom stop
//						if let stop = leg.legStopsViewData.last {
//							LegStopView(
//								type: stop.stopOverType,
//								stopOver: stop,
//								leg: leg,
//								showBadges: false,
//								shevronIsExpanded: .expanded
//							)
//						}
//					default:
//						Text("error")
//					}
//				}
//				// MARK: Progress line
//				.background {
//					ZStack(alignment: .top) {
//						VStack{
//							HStack(alignment: .top) {
//								Rectangle()
//									.fill(Color.chewGrayScale10)
//									.frame(width: 18,height:  totalProgressHeight)
//									.padding(.leading,26)
//								Spacer()
//							}
//							Spacer(minLength: 0)
//						}
//						VStack {
//							HStack(alignment: .top) {
//								RoundedRectangle(cornerRadius: totalProgressHeight == currentProgressHeight ? 0 : 6)
//									.fill(Color.chewFillGreenPrimary)
//									.cornerRadius(totalProgressHeight == currentProgressHeight ? 0 : 6)
//									.frame(width: 20,height: currentProgressHeight)
//									.padding(.leading,25)
//								Spacer()
//							}
//							Spacer(minLength: 0)
//						}
//					}
//				}
//			}
//		}
//		.padding(5)
//	}
//}

struct Preview : PreviewProvider {
	static var previews: some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip,
		   let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock]) {
			FullLegSheet(
				journeyViewModel: .init(
					followId: 0,
					data: .init(journeyRef: "", badges: [], sunEvents: [], legs: [], depStopName: nil, arrStopName: nil, time: .init(), updatedAt: 0),
					depStop: .init(),
					arrStop: .init(),
					chewVM: .init(),
					initialStatus: .fullLeg(leg: viewData)
				),
				closeSheet: {}
			)
			.environmentObject(ChewViewModel())
//			FullLegView(leg: viewData, journeyDetailsViewModel: nil)
		} else {
			Text("error")
		}
	}
}
