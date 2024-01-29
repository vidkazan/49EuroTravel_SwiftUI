////
////  NewSearchStopsView.swift
////  Chew-chew-SwiftUI
////
////  Created by Dmitrii Grigorev on 28.01.24.
////
//
//import Foundation
//import SwiftUI
//
//
//struct NewSearchStopsView: View {
//	@EnvironmentObject  var chewViewModel : ChewViewModel
//	@ObservedObject var searchStopViewModel : SearchStopsViewModel
//	@FocusState 	var focusedField : LocationDirectionType?
//	@State var previuosStatus : ChewViewModel.Status?
//	@State var topText : String
//	@State var bottomText : String
//	@State var fieldRedBorder : (top: Bool,bottom: Bool) = (false,false)
//	init(vm : SearchStopsViewModel) {
//		self.topText = ""
//		self.bottomText = ""
//		self.searchStopViewModel = vm
//	}
//	
//	var body: some View {
//		VStack(spacing: 5) {
//			// MARK: TopField
//				VStack {
//					HStack {
//						HStack(spacing: 0){
//							TextField(type.placeholder, text: textBinding)
//								.submitLabel(.done)
//								.keyboardType(.alphabet)
//								.autocorrectionDisabled(true)
//								.padding(10)
//								.chewTextSize(.big)
//								.frame(maxWidth: .infinity,alignment: .leading)
//								.focused(focusedFieldBinding, equals: type)
//								.onChange(of: text, perform: { text in
//									guard chewViewModel.state.status == .editingStop(.arrival) &&
//											searchStopViewModel.state.type == .arrival ||
//											chewViewModel.state.status == .editingStop(.departure) &&
//											searchStopViewModel.state.type == .departure else { return }
//									if focusedField == searchStopViewModel.state.type && text.count > 2 {
//										searchStopViewModel.send(event: .onSearchFieldDidChanged(text,type))
//									}
//									if focusedField == nil || text.isEmpty {
//										searchStopViewModel.send(event: .onReset(type))
//									}
//								})
//								.onTapGesture {
//									chewViewModel.send(event: .onStopEdit(type))
//								}
//								.onSubmit {
//									chewViewModel.send(event: .onNewStop(.textOnly(text), type))
//								}
//							VStack {
//								if focusedField == type && text.count > 0 {
//									Button(action: {
//										textBinding.wrappedValue = ""
//									}, label: {
//										Image(systemName: "xmark.circle")
//											.chewTextSize(.big)
//											.tint(.gray)
//										
//									})
//									.frame(width: 40,height: 40)
//								}
//							}
//							.transition(.opacity)
//							.animation(.spring(response: 0.1), value: text.count)
//							Spacer()
//						}
//					}
//					.background(Color.chewFillAccent)
//					.animation(.spring(), value: chewViewModel.state.status)
//					.cornerRadius(10)
//					.overlay(
//						RoundedRectangle(cornerRadius: 10)
//							.stroke(fieldRedBorder.top == true ? .red : .clear, lineWidth: 1.5)
//					)
//					if case .editingStop(.departure) = chewViewModel.state.status {
//							stopList(type: .departure)
//					}
//				}
//			.background(Color.chewFillSecondary)
//			.cornerRadius(10)
//		}
//		.onChange(of: chewViewModel.state, perform: { state in
//			topText = state.depStop.text
//			bottomText = state.arrStop.text
//			
//			fieldRedBorder.bottom = state.arrStop.stop == nil && !state.arrStop.text.isEmpty && state.status != .editingStop(.arrival)
//			fieldRedBorder.top = state.depStop.stop == nil && !state.depStop.text.isEmpty && state.status != .editingStop(.departure)
//			
//			switch state.status {
//			case .editingStop(let type):
//				focusedField = type
//				switch type {
//				case .arrival:
//					bottomText = ""
//				case .departure:
//					topText = ""
//				}
//			default:
//				focusedField = nil
//			}
//			
//			previuosStatus = chewViewModel.state.status
//		})
//	}
//}
