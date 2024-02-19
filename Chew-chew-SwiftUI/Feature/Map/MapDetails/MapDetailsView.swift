import SwiftUI
import MapKit

struct MapDetailsUIView: UIViewRepresentable {
	let legs : [MapLegData]
	let region: MKCoordinateRegion
	
	class Coordinator: NSObject, MKMapViewDelegate {
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor.white
			renderer.lineWidth = 5
			return renderer
		}
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		legs.forEach({ leg in
			let annotations : [MKPointAnnotation] = leg.stops.map {
				let annotation = MKPointAnnotation()
				annotation.coordinate = $0.locationCoordinates
				annotation.title = $0.name
				return annotation
			}
			
			mapView.addAnnotations(annotations)
			if let route = leg.route {
				mapView.addOverlay(route)
			}
		})

		mapView.delegate = context.coordinator
		mapView.region = region
		mapView.showsUserLocation = true
		
		mapView.isZoomEnabled = true
		mapView.isUserInteractionEnabled = true
		return mapView
	}

	func updateUIView(_ view: MKMapView, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
}

struct MapDetailsView: View {
	@State var mapRect : MKCoordinateRegion
	let legs : [MapLegData]
//	let stops : [StopViewData]
//	let route : MKPolyline?
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
