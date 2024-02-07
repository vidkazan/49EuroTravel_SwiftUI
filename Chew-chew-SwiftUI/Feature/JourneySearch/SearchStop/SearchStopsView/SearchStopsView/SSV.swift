//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI
import CoreLocation

struct SearchStopsView: View {
	@EnvironmentObject  var chewViewModel : ChewViewModel
	@ObservedObject var searchStopViewModel : SearchStopsViewModel = Model.shared.searchStopsViewModel
	@FocusState 	var focusedField : LocationDirectionType?
	@State var previuosStatus : ChewViewModel.Status?
	@State var topText : String
	@State var bottomText : String
	@State var fieldRedBorder : (top: Bool,bottom: Bool) = (false,false)
	init() {
		self.topText = ""
		self.bottomText = ""
	}
	
	var body: some View {
		VStack(spacing: 5) {
			// MARK: TopField
				VStack {
					HStack {
						textField(
							type: .departure,
							text: topText,
							textBinding: $topText,
							focusedField: focusedField,
							focusedFieldBinding: $focusedField
						)
						rightButton(type: .departure)
					}
					.background(Color.chewFillAccent)
					.animation(.spring(), value: chewViewModel.state.status)
					.cornerRadius(10)
					.overlay(
						RoundedRectangle(cornerRadius: 10)
							.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
					)
					if case .editingStop(.departure) = chewViewModel.state.status {
						stopList(type: .departure)
					}
				}
			.background(Color.chewFillSecondary)
			.cornerRadius(10)
			// MARK: BottomField
			VStack {
				HStack {
					textField(
						type: .arrival,
						text: bottomText,
						textBinding: $bottomText,
						focusedField: focusedField,
						focusedFieldBinding: $focusedField
					)
					rightButton(type: .arrival)
				}
				.background(Color.chewFillAccent)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.bottom == true ? .red : .clear, lineWidth: 1.5)
				)
				if case .editingStop(.arrival) = chewViewModel.state.status {
					stopList(type: .arrival)
				}
			}
			.background(Color.chewFillSecondary)
			.cornerRadius(10)
		}
		.onChange(of: chewViewModel.state, perform: { state in
			topText = state.depStop.text
			bottomText = state.arrStop.text
			
			fieldRedBorder.bottom = state.arrStop.stop == nil && !state.arrStop.text.isEmpty && state.status != .editingStop(.arrival)
			fieldRedBorder.top = state.depStop.stop == nil && !state.depStop.text.isEmpty && state.status != .editingStop(.departure)
			
			switch state.status {
			case .editingStop(let type):
				focusedField = type
				switch type {
				case .arrival:
					bottomText = ""
				case .departure:
					topText = ""
				}
			default:
				focusedField = nil
			}
			
			previuosStatus = chewViewModel.state.status
		})
	}
}
