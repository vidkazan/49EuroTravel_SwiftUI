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
	@ObservedObject var searchStopViewModel : SearchLocationViewModel
	@FocusState	var focusedField : LocationDirectionType?
	@State var topText : String
	@State var bottomText : String
	init() {
		self.searchStopViewModel = SearchLocationViewModel()
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
				.background(chewViewModel.state.status == .editingDepartureStop ?  Color.chewGray20 : Color.chewGray10)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
				if case .departure = searchStopViewModel.state.type {
					stopList(type: .departure)
				}
			}
				.background(Color.chewGray10)
				.cornerRadius(10)
				.transition(.move(edge: .bottom))
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
				.background(chewViewModel.state.status == .editingArrivalStop ?  Color.chewGray20 : Color.chewGray10)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
				if case .arrival = searchStopViewModel.state.type {
					stopList(type: .arrival)
				}
			}
			.background(Color.chewGray10)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
		}
		.onChange(of: chewViewModel.state, perform: { state in
			if let depStop = state.depStop {
				topText = depStop.name
			} else {
				topText = ""
			}
			if let arrStop = state.arrStop {
				bottomText = arrStop.name
			}  else {
				bottomText = ""
			}
				switch state.status {
				case .editingDepartureStop:
					focusedField =  .departure
				case .editingArrivalStop:
					focusedField =  .arrival
				default:
					focusedField = nil
				}
		})
	}
}

