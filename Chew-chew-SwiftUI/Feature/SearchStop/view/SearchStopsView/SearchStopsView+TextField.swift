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
		focusedField : LocationDirectionType?,
		focusedFieldBinding : FocusState<LocationDirectionType?>.Binding
	) -> some View {
		return TextField(type.placeholder, text: textBinding)
			.autocorrectionDisabled(true)
			.padding(10)
			.chewTextSize(.big)
			.frame(maxWidth: .infinity,alignment: .leading)
			.focused(focusedFieldBinding, equals: type)
			.onChange(of: text, perform: { text in
				guard chewViewModel.state.status == .editingArrivalStop ||
						chewViewModel.state.status == .editingDepartureStop else { return }
				if focusedField != nil && text.count > 2 {
					 searchStopViewModel.send(event: .onSearchFieldDidChanged(text,type))
				 }
				if focusedField == nil || text.isEmpty {
					 searchStopViewModel.send(event: .onReset(type))
				 }
			})
			.onTapGesture {
				switch type {
				case .departure:
					chewViewModel.send(event: .onDepartureEdit)
				case .arrival:
					chewViewModel.send(event: .onArrivalEdit)
				}
			}
	}
}
