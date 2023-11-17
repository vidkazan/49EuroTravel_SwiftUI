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
	@FocusState	var focusedField : LocationDirectionType?
	@State var topTextStore : String
	@State var bottomTextStore : String
	@State var topText : String
	@State var bottomText : String
	init(vm : SearchStopsViewModel) {
		self.topText = ""
		self.bottomText = ""
		self.topTextStore = ""
		self.bottomTextStore = ""
		self.searchStopViewModel = vm
	}
	
	// TODO: textField red border if:
	//	- finished editing text
	//	- field not empty
	//	- field not valid
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
				//				.background(chewViewModel.state.status == .editingDepartureStop ?  Color.chewGray20 : Color.chewGray10)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
//				if case .departure = searchStopViewModel.state.type, case .editingDepartureStop=chewViewModel.state.status {
					if case .editingDepartureStop=chewViewModel.state.status {
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
				.background(Color.chewGray10)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
//				if case .arrival = searchStopViewModel.state.type, case .editingArrivalStop=chewViewModel.state.status {
				if case .editingArrivalStop=chewViewModel.state.status {
					stopList(type: .arrival)
				}
			}
			.background(Color.chewGray10)
			.cornerRadius(10)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
		}
		.onChange(of: chewViewModel.state, perform: { state in
			topText = state.depStop?.name ?? ""
			bottomText = state.arrStop?.name ?? ""
			if let type = searchStopViewModel.state.type {
				searchStopViewModel.send(event: .onReset(type))
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

