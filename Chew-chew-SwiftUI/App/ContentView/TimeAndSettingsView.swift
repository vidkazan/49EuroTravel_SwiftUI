//
//  TimeAndSettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.
//

import Foundation
import SwiftUI

struct TimeAndSettingsView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var state : ChewViewModel.State = .init()
	let setSheetType : (JourneySearchView.SheetType)->Void

	init(setSheetType: @escaping (JourneySearchView.SheetType) -> Void) {
		self.setSheetType = setSheetType
	}
	
	var body: some View {
		Group {
			VStack(spacing: 0) {
				HStack {
					TimeChoosingView(
						searchStopsVM: chewViewModel.searchStopsViewModel,
						setSheetType: setSheetType
					)
					Button(action: {
//						setSheetType(.settings)
						chewViewModel.sheetViewModel.send(event: .didRequestShow(.settings))
					}, label: {
						Image(.gearshape)
							.tint(.primary)
							.frame(maxWidth: 43,maxHeight: 43)
							.background(Color.chewFillAccent)
							.cornerRadius(8)
							.overlay(alignment: .topTrailing) {
								Circle()
									.fill(Color.chewFillRedPrimary)
									.frame(width: 10,height: 10)
									.padding(5)
							}
					})
				}
			}
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
	
	struct TimeAndSettingsPreview : PreviewProvider {
		static var previews: some View {
			TimeAndSettingsView(setSheetType: { _ in })
				.padding(10)
				.environmentObject(ChewViewModel(referenceDate: .now))
				.background(Color.chewFillPrimary)
		}
	}
}
