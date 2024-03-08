import SwiftUI
import OrderedCollections
import MapKit

struct MapDetailsView: View {
	@State var mapRect : MKCoordinateRegion
	let legs :  OrderedSet<MapLegData>
	var body: some View {
		Group {
			if #available(iOS 16.0, *) {
				MapDetailsUIView(legs: legs, region: mapRect)
					.presentationDetents([.large])
			} else {
				MapDetailsUIView(legs: legs, region: mapRect)
			}
		}
		.background(Color.chewFillPrimary)
		.cornerRadius(8)
		.padding(5)
	}
}
