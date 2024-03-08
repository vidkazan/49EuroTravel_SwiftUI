import SwiftUI
import OrderedCollections
import MapKit

struct MapDetailsView: View {
	@State var mapRect : MKCoordinateRegion
	let legs :  OrderedSet<MapLegData>
	var body: some View {
		MapDetailsUIView(legs: legs, region: mapRect)
		.background(Color.chewFillPrimary)
		.cornerRadius(8)
		.padding(5)
	}
}
