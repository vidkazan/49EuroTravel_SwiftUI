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
	@State var topText : String
	@State var bottomText : String
	@State var fieldRedBorder : LocationDirectionType? = nil
	init(vm : SearchStopsViewModel) {
		self.topText = ""
		self.bottomText = ""
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
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder == .departure ? .red : .clear, lineWidth: 1.5)
				)
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
				.cornerRadius(10)
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(fieldRedBorder == .arrival ? .red : .clear, lineWidth: 1.5)
				)
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
			fieldRedBorder = nil
			if let dep = chewViewModel.state.depStop {
				topText = dep.name
			} else if !topText.isEmpty, state.status != .editingDepartureStop {
				fieldRedBorder = .departure
			}
			if let arr = chewViewModel.state.arrStop {
				bottomText = arr.name
			} else if !bottomText.isEmpty, state.status != .editingArrivalStop {
				fieldRedBorder = .arrival
			}
			
//			if let type = searchStopViewModel.state.type {
//				searchStopViewModel.send(event: .onReset(type))
//			}
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
		})
	}
}

