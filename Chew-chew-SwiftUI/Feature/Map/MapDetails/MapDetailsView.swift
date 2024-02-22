import SwiftUI
import OrderedCollections
import MapKit

struct MapDetailsView: View {
	@State var mapRect : MKCoordinateRegion
	let legs :  OrderedSet<MapLegData>
	let closeSheet : ()->Void
	var body: some View {
		Group {
			if #available(iOS 16.0, *) {
				sheet
					.presentationDetents([.medium])
			} else {
				sheet
			}
		}
		.background(Color.chewFillPrimary)
		.cornerRadius(8)
		.padding(5)
	}
}

extension MapDetailsView {
	var sheet : some View {
		NavigationView {
			MapDetailsUIView(legs: legs, region: mapRect)
			.navigationTitle("Map")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						closeSheet()
					}
				})
			}
		}
	}
}


struct MapDetails_Previews: PreviewProvider {
	static var previews: some View {
		if let mock = Mock
			.journeys
			.journeyNeussWolfsburg
			.decodedData?
			.journey
			.journeyViewData(
				depStop: .init(),
				arrStop: .init(),
				realtimeDataUpdatedAt: 0
			) {
			MapDetailsView(
				mapRect: SheetViewModel.constructMapRegion(
					locFirst: mock.legs.first?.legStopsViewData.first?.locationCoordinates ?? .init(),
					locLast: mock.legs.last?.legStopsViewData.last?.locationCoordinates ?? .init()
				),
				legs: .init( mock.legs.compactMap({MapLegData(
					type: $0.legType,
					lineType: $0.lineViewData.type,
					stops: $0.legStopsViewData,
					route: nil
				)})),
				closeSheet: {}
			)
		}
	}
}
