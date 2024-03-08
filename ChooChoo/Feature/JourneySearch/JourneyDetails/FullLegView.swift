//
//  FullLegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.10.23.
//

import Foundation
import SwiftUI

struct FullLegSheet: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let leg : LegViewData
	var body: some View {
		ScrollView {
			VStack(alignment: .center,spacing: 0) {
				LegDetailsView(
					send: { _ in},
					referenceDate: chewVM.referenceDate,
					openSheet: { _  in },
					isExpanded: .expanded,
					leg: leg
				)
			}
		}
		.chewTextSize(.big)
		.frame(maxWidth: .infinity)
	}
}


struct Preview : PreviewProvider {
	static var previews: some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip,
		   let viewData = mock.legViewData(firstTS: .now, lastTS: .now, legs: [mock]) {
			FullLegSheet(leg: viewData)
			.environmentObject(ChewViewModel())
		} else {
			Text("error")
		}
	}
}
