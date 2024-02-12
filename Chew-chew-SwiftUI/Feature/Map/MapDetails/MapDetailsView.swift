import SwiftUI
import MapKit

struct MapDetailsUIView: UIViewRepresentable {
	let stops : [StopViewData]
	let region: MKCoordinateRegion
	let route : MKPolyline?
	
	class Coordinator: NSObject, MKMapViewDelegate {
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor.white
			renderer.lineWidth = 5
			return renderer
		}
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let annotations : [MKPointAnnotation] = stops.map {
			let annotation = MKPointAnnotation()
			annotation.coordinate = $0.locationCoordinates
			annotation.title = $0.name
			return annotation
		}
		let mapView = MKMapView()
		mapView.addAnnotations(annotations)
		if let route = route {
			mapView.addOverlay(route)
		}

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
	let stops : [StopViewData]
	let route : MKPolyline?
	let closeSheet : ()->Void
	var body: some View {
		NavigationView {
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
			MapDetailsUIView(stops: stops, region: mapRect, route: route)
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
