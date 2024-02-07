import SwiftUI
import MapKit

struct MapWithCoordinatePickerView: View {
	@State private var selectedCoordinate: CLLocationCoordinate2D?

	var body: some View {
		VStack {
			MapWithCoordinatePickerUIView(
				selectedCoordinate: $selectedCoordinate
			)
				.edgesIgnoringSafeArea(.all)
			Text("Selected Coordinates: \(selectedCoordinate?.latitude ?? 0), \(selectedCoordinate?.longitude ?? 0)")
				.padding()
		}
	}
}

struct MapWithCoordinatePickerUIView: UIViewRepresentable {
	@Binding var selectedCoordinate: CLLocationCoordinate2D?

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		let initialLocation = CLLocationCoordinate2D(
			latitude: 52.4,
			longitude: 10.8
		)
		let span = MKCoordinateSpan(
			latitudeDelta: 0.1,
			longitudeDelta: 0.1
		)
		let region = MKCoordinateRegion(center: initialLocation, span: span)
		mapView.setRegion(region, animated: true)

		let gestureRecognizer = UITapGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.handleTap(_:))
		)
		mapView.addGestureRecognizer(gestureRecognizer)

		return mapView
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		// Update the view when the selected coordinate changes
		if let selectedCoordinate = selectedCoordinate {
			let annotation = MKPointAnnotation()
			annotation.coordinate = selectedCoordinate
			uiView.removeAnnotations(uiView.annotations)
			uiView.addAnnotation(annotation)

			// Center the map on the selected coordinate
			uiView.setCenter(selectedCoordinate, animated: true)
		}
	}
}

extension MapWithCoordinatePickerUIView {
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapWithCoordinatePickerUIView

		init(parent: MapWithCoordinatePickerUIView) {
			self.parent = parent
		}

		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let annotation = view.annotation as? MKPointAnnotation {
				parent.selectedCoordinate = annotation.coordinate
			}
		}
		
		
		@objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
			let mapView = gestureRecognizer.view as? MKMapView
			
			let location = gestureRecognizer.location(in: mapView)
			let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
			parent.selectedCoordinate = coordinate
		}
		
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			let identifier = "Placemark"
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

			if annotationView == nil {
				annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				annotationView?.canShowCallout = true
			} else {
				annotationView?.annotation = annotation
			}

			return annotationView
		}
		
	}

}

struct MapWithCoordinatePickerView_Previews: PreviewProvider {
	static var previews: some View {
		MapWithCoordinatePickerView()
	}
}
