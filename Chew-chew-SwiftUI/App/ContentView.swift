//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI


// TODO: move all logic from views
struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var dateViewSheetIsPresented : Bool
	
	var body: some View {
		NavigationView {
			ZStack {
				VStack(spacing: 5) {
					SearchStopsView(vm: chewViewModel.searchStopsViewModel)
					TimeChoosingView(searchStopsVM: chewViewModel.searchStopsViewModel)
					if case .journeys(let vm) = chewViewModel.state.status {
						JourneysListView(journeyViewModel: vm)
							.padding(.top,10)
					} else if case .idle = chewViewModel.state.status  {
						FavouriteRidesView()
							.padding(.top,10)
						Spacer()
					} else {
						Spacer()
					}
				}
				.padding(10)
			}
			.background( .linearGradient(
				colors: colorScheme == .dark ? [.black] : [Color(hue: 0, saturation: 0, brightness: 0.85)],
				startPoint: UnitPoint(x: 0.5, y: 0.1),
				endPoint: UnitPoint(x: 0.5, y: 0.4))
			)
			.sheet(isPresented: $dateViewSheetIsPresented,onDismiss: {
				chewViewModel.send(event: .didDismissDatePicker)
			}, content: {
				switch chewViewModel.state.status {
				case .datePicker:
					DatePickerView(sStartDate: chewViewModel.state.timeChooserDate.date)
				default:
					EmptyView()
				}
			})
			.onChange(of: chewViewModel.state.status, perform: { status in
				switch status {
				case .datePicker:
					dateViewSheetIsPresented = true
				default:
					dateViewSheetIsPresented = false
				}
			})
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: chewViewModel.state.status)
			.animation(.spring(), value: chewViewModel.searchStopsViewModel.state)
		}
	}
}
