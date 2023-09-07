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
					let tmp = searchStopViewModel.topSearchFieldText
					searchStopViewModel.topSearchFieldText = searchStopViewModel.bottomSearchFieldText
					searchStopViewModel.bottomSearchFieldText = tmp
				}
				
			},
			label: {
				switch searchStopViewModel.state {
				case .loading((_), let typ):
					if type == typ {
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
		let stops : [Stop] = {
			switch type {
			case .departure:
				return searchStopViewModel.searchLocationDataSource.searchLocationDataDeparture
			case .arrival:
				return searchStopViewModel.searchLocationDataSource.searchLocationDataArrival
			}
		}()
		return VStack { // stops
			ForEach(stops) { stop in
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
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
	
	func textField(type : LocationDirectionType,text: String, textBinding: Binding<String>, focusBinding: FocusState<Bool>.Binding,focus: Bool) -> some View {
		return TextField(type.placeholder, text: textBinding)
			.focused(focusBinding)
			 .onTapGesture {
				 switch type {
				 case .departure:
					 searchStopViewModel.topSearchFieldText = ""
				 case .arrival:
					 searchStopViewModel.bottomSearchFieldText = ""
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
			 .font(.system(size: 17,weight: .semibold))
			 .frame(maxWidth: .infinity,alignment: .leading)
	}
}
