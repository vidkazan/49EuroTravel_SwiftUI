//
//  SearchStopsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.09.23.
//

import SwiftUI
import CoreLocation

struct SearchStopsView: View {
	@Namespace var searchStopsViewNamespace
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
			// MARK: TopField
			VStack(spacing: 0) {
				HStack {
					textField(
						type: .departure,
						text: $topText
					)
					.matchedGeometryEffect(id: "topField", in: searchStopsViewNamespace)
					rightButton(type: .departure)
						.matchedGeometryEffect(id: "topBtn", in: searchStopsViewNamespace)
				}
				.background(Color.chewFillAccent)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
					.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
				)
				if focusedField == .departure {
					stopList(type: .departure)
						.matchedGeometryEffect(id: "topList", in: searchStopsViewNamespace)
				}
			}
			.background(Color.chewFillSecondary.opacity(0.7))
			.cornerRadius(10)
			// MARK: BottomField
			VStack(spacing: 0) {
				HStack {
					textField(
						type: .arrival,
						text: $bottomText
					)
					.matchedGeometryEffect(id: "bottomField", in: searchStopsViewNamespace)
					rightButton(type: .arrival)
						.matchedGeometryEffect(id: "bottomBtn", in: searchStopsViewNamespace)
				}
				.background(Color.chewFillAccent)
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder.bottom == true ? .red : .clear, lineWidth: 1.5)
				)
				if focusedField == .arrival {
					stopList(type: .arrival)
						.matchedGeometryEffect(id: "bottomList", in: searchStopsViewNamespace)
				}
			}
			.background(Color.chewFillSecondary.opacity(0.7))
			.cornerRadius(10)
		}
		.animation(.easeInOut, value: chewViewModel.state.status)
		.animation(.easeInOut, value: searchStopViewModel.state.status)
		.animation(.easeInOut, value: topText)
		.animation(.easeInOut, value: bottomText)
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
