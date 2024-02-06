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
	let closeSheet : ()->Void
	
	var body: some View {
		NavigationView {
			ScrollView {
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
							openSheet: { _  in },
							isExpanded: .expanded,
							leg: leg
						)
					default:
						EmptyView()
					}
				}
			}
			.chewTextSize(.big)
			.frame(maxWidth: .infinity)
			.background(Color.chewFillAccent)
			.navigationTitle("Full leg")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						journeyViewModel.send(event: .didCloseBottomSheet)
//						closeSheet()
					}
				})
			}
		}
	}
}


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
		} else {
			Text("error")
		}
	}
}
