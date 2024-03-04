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
					.presentationDetents([.medium,.large])
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

