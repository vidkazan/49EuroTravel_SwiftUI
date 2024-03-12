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
	@State var status : ChewViewModel.Status = .idle
	@State var topText : String = ""
	@State var bottomText : String = ""
	@State var fieldRedBorder : (top: Bool,bottom: Bool) = (false,false)
	
	var body: some View {
		VStack(spacing: 5) {
			// MARK: TopField
			VStack {
				HStack {
					textField(
						type: .departure,
						text: $topText
					)
					rightButton(type: .departure)
				}
				.background(Color.chewFillAccent)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
				)
				if focusedField == .departure {
					StopList(fieldText: topText, type: .departure)
				}
			}
			.background(Color.chewFillSecondary.opacity(0.7))
			.cornerRadius(10)
			// MARK: BottomField
			VStack {
				HStack {
					textField(
						type: .arrival,
						text: $bottomText
					)
					rightButton(type: .arrival)
				}
				.background(Color.chewFillAccent)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.bottom == true ? .red : .clear, lineWidth: 1.5)
				)
				if focusedField == .arrival {
					StopList(fieldText: bottomText, type: .arrival)
				}
			}
			.background(Color.chewFillSecondary.opacity(0.7))
			.cornerRadius(10)
		}
		.onReceive(chewViewModel.$state, perform: { state in
			Task {
				self.status = state.status
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
				
				previuosStatus = state.status
			}
		})
	}
}
