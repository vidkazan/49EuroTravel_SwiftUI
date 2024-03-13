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
	@State var recentStopsData = [StopWithDistance]()
	@State var stops = [StopWithDistance]()
	@State var fieldRedBorder : (top: Bool,bottom: Bool) = (false,false)
	
	var body: some View {
		VStack(spacing: 5) {
			field(type: .departure, text: $topText)
			field(type: .arrival, text: $bottomText)
		}
//		.animation(.easeInOut, value: chewViewModel.state.status)
//		.animation(.easeInOut, value: searchStopViewModel.state.status)
//		.animation(.easeInOut, value: topText)
//		.animation(.easeInOut, value: bottomText)
		.onReceive(chewViewModel.$state, perform: onStateChange)
	}
}

extension SearchStopsView {
	func field(type : LocationDirectionType, text : Binding<String>) -> some View {
		 VStack(spacing: 0) {
			HStack {
				textField(
					type: type,
					text: text
				)
				rightButton(type: type)
			}
			.background(Color.chewFillAccent)
			.cornerRadius(10)
			.overlay(
				redStroke(type: type)
			)
			if focusedField == type {
				stopList(type: type)
			}
		}
		.background(Color.chewFillSecondary.opacity(0.7))
		.clipShape(.rect(cornerRadius: 10))
	}
	
	func redStroke(type : LocationDirectionType) -> some View {
		switch type {
		case .departure:
			RoundedRectangle(cornerRadius: 10)
			.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
		case .arrival:
			RoundedRectangle(cornerRadius: 10)
			.stroke(fieldRedBorder.bottom == true ? .red : .clear, lineWidth: 1.5)
		}
	}
}

extension SearchStopsView {
	func onStateChange(state : ChewViewModel.State) {
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
}
