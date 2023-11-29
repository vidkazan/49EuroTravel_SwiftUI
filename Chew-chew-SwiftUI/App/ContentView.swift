//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

// TODO: place save / done buttons in sheet at top
// TODO: legView: place transport icons
// TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce
// TODO: .reducted (placeholder view) with mock data
// TODO: coreData: settings entity: save: update line instead of creating new
// TODO: move all logic from views
// TODO: bug: journey: if arrival stop cancelled, duration is NULL
// TODO: bug: journey: stop is showing totally cancelled if only exit / entrance is allowed
struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@Environment(\.managedObjectContext) var viewContext
	@State var bottomSheetIsPresented : Bool = false
	
	var body: some View {
		NavigationView {
			switch chewViewModel.state.status {
			case .start:
				EmptyView()
			default:
				ZStack {
					VStack(spacing: 5) {
						SearchStopsView(vm: chewViewModel.searchStopsViewModel)
						HStack {
							TimeChoosingView(searchStopsVM: chewViewModel.searchStopsViewModel)
							Button(action: {
								chewViewModel.send(event: .didTapSettings)
							}, label: {
								Image(systemName: "gearshape")
									.tint(.white)
									.frame(maxWidth: 43,maxHeight: 43)
									.background(Color.chewGray10)
									.cornerRadius(8)
							})
						}
						if case .journeys(let vm) = chewViewModel.state.status {
							JourneyListListView(journeyViewModel: vm)
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
				.sheet(
					isPresented: $bottomSheetIsPresented,
					onDismiss: {
						chewViewModel.send(event: .didDismissBottomSheet)
					},
					content: {
						switch chewViewModel.state.status {
						case .settings:
							SettingsView(settings: chewViewModel.state.settings)
						case .datePicker:
							DatePickerView(
								date: chewViewModel.state.timeChooserDate.date,
								time: chewViewModel.state.timeChooserDate.date
							)
						default:
							EmptyView()
						}
				})
				.onChange(of: chewViewModel.state.status, perform: { status in
					switch status {
					case .datePicker,.settings:
						bottomSheetIsPresented = true
					default:
						bottomSheetIsPresented = false
					}
				})
				.navigationBarHidden(true)
				.transition(.opacity)
				.animation(.spring().speed(2), value: chewViewModel.state.status)
				.animation(.spring().speed(2), value: chewViewModel.searchStopsViewModel.state)
			}
			}
			.onAppear {
				chewViewModel.send(event: .didStartViewAppear(viewContext))
			}
		}
	}

//struct Preview : PreviewProvider {
//	static var previews: some View {
//		ContentView()
//			.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//	}
//}
