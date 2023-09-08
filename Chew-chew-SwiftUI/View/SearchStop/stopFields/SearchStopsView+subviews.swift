//
//  SearchStopsView+subviews.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//
import SwiftUI

extension SearchStopsView {
	func rightButton(type : LocationDirectionType) -> some View {
		let image : Image = {
			switch type {
			case .departure:
				return Image(systemName: "location")
			case .arrival:
				return Image(systemName: "arrow.up.arrow.down")
			}
		}()
		return Button(
			action: {
				switch type {
				case .departure:
					return
				case .arrival:
					searchJourneyViewModel.send(event: .onStopsSwitch)
					let tmp = searchJourneyViewModel.topSearchFieldText
					searchJourneyViewModel.topSearchFieldText = searchJourneyViewModel.bottomSearchFieldText
					searchJourneyViewModel.bottomSearchFieldText = tmp
				}
				
			},
			label: {
					switch searchStopViewModel.state.status {
					case .loading:
						if type == searchStopViewModel.state.type {
							ProgressView()
						} else {
							image
						}
					default:
						image
					}
			})
				.foregroundColor(.black)
	}
	
	func stopList(type : LocationDirectionType) -> some View {
		return VStack { // stops
				if searchStopViewModel.state.type == type {
					ForEach(searchStopViewModel.state.stops) { stop in
						if let text = stop.name {
							Button(text){
								switch type {
								case .departure:
									textTopFieldIsFocused = false
									searchJourneyViewModel.send(event: .onNewDeparture(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								case .arrival:
									textBottomFieldIsFocused = false
									searchJourneyViewModel.send(event: .onNewArrival(stop))
									searchStopViewModel.send(event: .onStopDidTap(stop, type))
								}
							}
							.foregroundColor(.black)
							.padding(5)
						}
					}
					.frame(maxWidth: .infinity,alignment: .leading)
				}
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
	
	func textField(type : LocationDirectionType,text: String, textBinding: Binding<String>, focusBinding: FocusState<Bool>.Binding,focus: Bool) -> some View {
		return TextField(type.placeholder, text: textBinding)
			.font(.system(size: 17,weight: .semibold))
			.frame(maxWidth: .infinity,alignment: .leading)
			.focused(focusBinding)
			 .onTapGesture {
				 switch type {
				 case .departure:
					 searchJourneyViewModel.topSearchFieldText = ""
				 case .arrival:
					 searchJourneyViewModel.bottomSearchFieldText = ""
				 }
			 }
			 .onChange(of: text, perform: { text in
					 if focus == true && text.count > 2 {
						 searchStopViewModel.send(event: .onSearchFieldDidChanged(text,type))
					 } else {
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
			 .onChange(of: searchStopViewModel.state.status) { status in
				if status == .idle {
					switch searchStopViewModel.state.type {
					case .departure:
						self.textTopFieldIsFocused = false
					case .arrival:
						self.textBottomFieldIsFocused = false
					}
				}
			}
	}
}
