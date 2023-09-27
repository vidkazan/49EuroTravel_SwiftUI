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
	
	init(searchStopViewModel: SearchLocationViewModel) {
		self.searchStopViewModel = searchStopViewModel
	}
	
	var body: some View {
		VStack{
			VStack {
				HStack {
					textField(
						type: .departure,
						text: chewViewModel.topSearchFieldText,
						textBinding: $chewViewModel.topSearchFieldText,
						focusedField: focusedField,
						focusedFieldBinding: $focusedField
					)
					rightButton(type: .departure)
				}
				.background(chewViewModel.state.status == .editingDepartureStop ?  Color.chewGray30 : Color.chewGray15)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
				if searchStopViewModel.state.type == .departure {
					stopList(type: .departure)
				}
			}
			.background(Color.chewGray15)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
			VStack {
				HStack {
					textField(
						type: .arrival,
						text: chewViewModel.bottomSearchFieldText,
						textBinding: $chewViewModel.bottomSearchFieldText,
						focusedField: focusedField,
						focusedFieldBinding: $focusedField
					)
					rightButton(type: .arrival)
				}
				.background(chewViewModel.state.status == .editingArrivalStop ?  Color.chewGray30 : Color.chewGray15)
				.animation(.spring(), value: chewViewModel.state.status)
				.cornerRadius(10)
				if searchStopViewModel.state.type == .arrival {
					stopList(type: .arrival)
				}
			}
			.background(Color.chewGray15)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchStopViewModel.state.status)
		}
		.onChange(of: chewViewModel.state.status, perform: { s in
			focusedField = {
				switch s {
				case .editingDepartureStop:
					return .departure
				case .editingArrivalStop:
					return .arrival
				default:
					return nil
				}
			}()
		})
	}
}

