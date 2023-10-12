//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject private var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool
	let solar = Solar(coordinate: CLLocationCoordinate2D(
		latitude: 51.3,
		longitude: 9.4)
	)
	
	var body: some View {
		NavigationView {
			ZStack {
				VStack(spacing: 5) {
					SearchStopsView()
					TimeChoosingView()
					if case .journeys(let vm) = chewViewModel.state.status {
						JourneysListView(journeyViewModel: vm)
							.padding(.top,10)
					} else {
						FavouriteRidesView()
							.padding(.top,10)
						Spacer()
					}
				}
				.padding(10)
//				if chewViewModel.state.status == .datePicker {
//					DatePickerView(sStartDate: chewViewModel.state.timeChooserDate.date)
//				}
			}
			.background( .linearGradient(
				colors: colorScheme == .dark ? [.black] : [Color(hue: 0, saturation: 0, brightness: 0.85)],
				startPoint: UnitPoint(x: 0.5, y: 0.1),
				endPoint: UnitPoint(x: 0.5, y: 0.4))
			)
			.sheet(isPresented: $bottomSheetIsPresented, content: {
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
					bottomSheetIsPresented = true
				default:
					bottomSheetIsPresented = false
				}
			})
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: chewViewModel.state.status)
		}
	}
}
