//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI
import CoreLocation

struct SearchStopsView: View {
	@Environment(\.managedObjectContext) var viewContext
	@EnvironmentObject  var chewViewModel : ChewViewModel
	@ObservedObject var searchStopViewModel : SearchStopsViewModel
	@FocusState 	var focusedField : LocationDirectionType?
	@State var previuosStatus : ChewViewModel.Status?
	@State var topText : String
	@State var bottomText : String
	@State var fieldRedBorder : (top: Bool,bottom: Bool) = (false,false)
	init(vm : SearchStopsViewModel) {
		self.topText = ""
		self.bottomText = ""
		self.searchStopViewModel = vm
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
				.background(Color.chewGray10)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
				)
				if case .editingDepartureStop=chewViewModel.state.status {
					stopList(type: .departure)
				}
			}
			.background(Color.chewGray10)
			.cornerRadius(10)
			.transition(.opacity)
//			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
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
				.background(Color.chewGray10)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.bottom == true ? .red : .clear, lineWidth: 1.5)
				)
				if case .editingArrivalStop=chewViewModel.state.status {
					stopList(type: .arrival)
				}
			}
			.background(Color.chewGray10)
			.cornerRadius(10)
			.transition(.opacity)
//			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
		}
		.onChange(of: chewViewModel.state, perform: { state in
			topText = state.depStop.text
			bottomText = state.arrStop.text
			
			fieldRedBorder.bottom = state.arrStop.stop == nil && !state.arrStop.text.isEmpty && state.status != .editingArrivalStop
			fieldRedBorder.top = state.depStop.stop == nil && !state.depStop.text.isEmpty && state.status != .editingDepartureStop
			
			switch state.status {
			case .editingDepartureStop:
				focusedField =  .departure
				topText = ""
			case .editingArrivalStop:
				focusedField =  .arrival
				bottomText = ""
			default:
				focusedField = nil
			}
			
			previuosStatus = chewViewModel.state.status
		})
	}
}

