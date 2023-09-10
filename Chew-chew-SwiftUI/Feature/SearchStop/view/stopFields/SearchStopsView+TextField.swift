//
//  SearchStopsView+subviews.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//
import SwiftUI

extension SearchStopsView {		
	func textField(
		type : LocationDirectionType,
		text: String,
		textBinding: Binding<String>,
		focusBinding: FocusState<Bool>.Binding,
		focus: Bool
	) -> some View {
		return TextField(type.placeholder, text: textBinding)
			.padding(10)
			.font(.system(size: 17,weight: .semibold))
			.frame(maxWidth: .infinity,alignment: .leading)
			.focused(focusBinding)
//			.onTapGesture {
//				 switch type {
//				 case .departure:
//					 searchJourneyViewModel.topSearchFieldText = ""
//				 case .arrival:
//					 searchJourneyViewModel.bottomSearchFieldText = ""
//				 }
//			}
			.onChange(of: text, perform: { text in
				 if focus == true && text.count > 2 {
					 searchStopViewModel.send(event: .onSearchFieldDidChanged(text,type))
				 }
				 if focus == false || text.isEmpty {
					 searchStopViewModel.send(event: .onReset(type))
				 }
			})
			.onChange(of: focus, perform: { focused in
				 if focused == true {
					 switch type {
					 case .departure:
						 searchJourneyViewModel.send(event: .onDepartureEdit)
					 case .arrival:
						 searchJourneyViewModel.send(event: .onArrivalEdit)
					 }
				 }
			})
	}
}
