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
				.submitLabel(.done)
				.keyboardType(.alphabet)
				.autocorrectionDisabled(true)
				.padding(10)
				.chewTextSize(.big)
				.frame(maxWidth: .infinity,alignment: .leading)
				.focused(focusedFieldBinding, equals: type)
				.onChange(of: text, perform: { text in
					guard chewViewModel.state.status == .editingStop(.arrival) &&
							searchStopViewModel.state.type == .arrival ||
							chewViewModel.state.status == .editingStop(.departure) &&
							searchStopViewModel.state.type == .departure else { return }
					if focusedField == searchStopViewModel.state.type && text.count > 2 {
						searchStopViewModel.send(event: .onSearchFieldDidChanged(text,type))
					}
					if focusedField == nil || text.isEmpty {
						searchStopViewModel.send(event: .onReset(type))
					}
				})
				.onTapGesture {
					chewViewModel.send(event: .onStopEdit(type))
				}
				.onSubmit {
					chewViewModel.send(event: .onNewStop(.textOnly(text), type))
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
					.frame(width: 40,height: 40)
				}
			}
			.transition(.opacity)
			.animation(.spring(response: 0.1), value: text.count)
			Spacer()
		}
	}
}
