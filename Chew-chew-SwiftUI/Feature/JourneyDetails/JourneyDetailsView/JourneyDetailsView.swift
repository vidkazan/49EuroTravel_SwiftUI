//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

struct JourneyDetailsView: View {
	// MARK: Fields
	enum SheetType : String {
		case none
		case map
		case fullLeg
	}
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyDetailsViewModel
	@State private var bottomSheetIsPresented : Bool = false
	@State var sheetType : SheetType = .none
	// MARK: Init
	init(journeyDetailsViewModel : JourneyDetailsViewModel) {
		viewModel = journeyDetailsViewModel
	}
	var body: some View {
		VStack {
			AlertsView(alertVM: chewVM.alertViewModel)
			ZStack {
				VStack {
					header()
						.padding(.horizontal,5)
						.padding(5)
					ScrollView {
						LazyVStack(spacing: 0){
							ForEach(viewModel.state.data.viewData.legs) { leg in
								LegDetailsView(
									send: viewModel.send,
									referenceDate: chewVM.referenceDate,
									openSheet: {type, leg in
										sheetType = type
									},
									isExpanded: .collapsed,
									leg: leg
								)}
							}
						}
						.padding(10)
					}
					// MARK: LegDetails - sheet
					.sheet(
						isPresented: $bottomSheetIsPresented,
						onDismiss: {
							sheetType = .none
						},
						content: {
							switch sheetType {
							case .fullLeg:
								FullLegSheet(
									journeyViewModel: viewModel,
									closeSheet: { sheetType = .none }
								)
							case .map:
								MapSheet(
									viewModel: viewModel,
									closeSheet: { sheetType = .none }
								)
							case .none:
								EmptyView()
							}
						}
					)
				}
				// MARK: Modifiers
				.background(Color.chewFillPrimary)
				.navigationBarTitle("Journey details", displayMode: .inline)
				.toolbar { toolbar() }
				// MARK: Modifiers - onChange
				.onChange(of: sheetType, perform: { type in
					switch type {
					case .none:
						bottomSheetIsPresented = false
					default:
						bottomSheetIsPresented = true
					}
				})
			}
		}
	}

struct JourneyDetailsPreview : PreviewProvider {
	static var previews: some View {
		let mocks = [
			Mock.journeys.journeyNeussWolfsburgFirstCancelled.decodedData!.journey,
			Mock.journeys.journeyNeussWolfsburg.decodedData!.journey
		]
		ScrollView(.horizontal) {
			LazyHStack {
				ForEach(mocks,id: \.id) { mock in
					let viewData = constructJourneyViewData(
						journey: mock,
						depStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
						arrStop:  .init(coordinates: .init(),type: .stop,stopDTO: nil),
						realtimeDataUpdatedAt: 0
					)
					JourneyDetailsView(
						journeyDetailsViewModel: JourneyDetailsViewModel(
							followId: nil,
							data: viewData!,
							depStop: .init(),
							arrStop: .init(),
							chewVM: .init()
						))
					.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData!.time.timestamp.departure.actual ?? 0) + 1000)))
				}
			}
		}
//		.previewDevice(PreviewDevice(.iPadMini6gen))
	}
}
