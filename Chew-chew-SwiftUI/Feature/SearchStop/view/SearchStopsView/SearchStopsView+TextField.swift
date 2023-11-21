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
		return HStack(spacing: 0){
			TextField(type.placeholder, text: textBinding)
				.keyboardType(.alphabet)
				.autocorrectionDisabled(true)
				.padding(10)
				.chewTextSize(.big)
				.frame(maxWidth: .infinity,alignment: .leading)
				.focused(focusedFieldBinding, equals: type)
				.onChange(of: text, perform: { text in
					guard chewViewModel.state.status == .editingArrivalStop &&
							searchStopViewModel.state.type == .arrival ||
							chewViewModel.state.status == .editingDepartureStop &&
							searchStopViewModel.state.type == .departure else { return }
					if focusedField == searchStopViewModel.state.type && text.count > 2 {
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
				.onSubmit {
					chewViewModel.send(event: .onNewDate(chewViewModel.state.timeChooserDate))
				}
			VStack {
				if focusedField == type && text.count > 0 {
					Button(action: {
						textBinding.wrappedValue = ""
					}, label: {
						Image(systemName: "xmark.circle")
							.chewTextSize(.big)
							.tint(.gray)
						
					})
				}
			}
			.transition(.opacity)
			.animation(.spring(response: 0.1), value: text.count)
			Spacer()
		}
	}
}
