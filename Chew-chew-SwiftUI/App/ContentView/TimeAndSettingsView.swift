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
	var body: some View {
		Group {
			switch state.status {
			case .editingStop:
				EmptyView()
			default:
				VStack(spacing: 0) {
					HStack {
						TimeChoosingView(searchStopsVM: chewViewModel.searchStopsViewModel)
						Button(action: {
							chewViewModel.send(event: .didTapSheet(.settings))
						}, label: {
							Image(systemName: "gearshape")
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
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
	
	struct TimeAndSettingsPreview : PreviewProvider {
		static var previews: some View {
			TimeAndSettingsView()
				.padding(10)
				.environmentObject(ChewViewModel())
				.background(Color.chewFillPrimary)
		}
	}
}
