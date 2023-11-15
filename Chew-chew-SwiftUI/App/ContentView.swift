//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI


// TODO: fix all TapZones
// TODO: move all logic from views
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
							Image(systemName: "gearshape")
								.frame(maxWidth: 43,maxHeight: 43)
								.onTapGesture {
									chewViewModel.send(event: .didTapSettings)
								}
								.background(Color.chewGray10)
								.cornerRadius(8)
						}
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
				.sheet(
					isPresented: $bottomSheetIsPresented,
					onDismiss: {
						chewViewModel.send(event: .didDismissBottomSheet)
					},
					content: {
						switch chewViewModel.state.status {
						case .settings:
							SettingsView(vm : chewViewModel)
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
				.navigationBarTitle("")
				.navigationBarHidden(true)
				.transition(.move(edge: .bottom))
				.animation(.spring(), value: chewViewModel.state.status)
				.animation(.spring(), value: chewViewModel.searchStopsViewModel.state)
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
