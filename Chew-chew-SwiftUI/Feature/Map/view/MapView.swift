import SwiftUI
import MapKit

struct MapWithCoordinatePickerUIView: UIViewRepresentable {
	@Binding var selectedCoordinate: CLLocationCoordinate2D?
	@Binding var mapCenterCoords: CLLocationCoordinate2D
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		let initialLocation = mapCenterCoords
		
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
		
		func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
			parent.mapCenterCoords = mapView.centerCoordinate
		}
		
		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let annotation = view.annotation as? MKPointAnnotation {
				parent.selectedCoordinate = annotation.coordinate
			}
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
		
		@objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
			let mapView = gestureRecognizer.view as? MKMapView

			let location = gestureRecognizer.location(in: mapView)
			let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
			parent.selectedCoordinate = coordinate
		}
	}

}

struct MapUIView: UIViewRepresentable {
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
	var body: some View {
		MapUIView(stops: stops, region: mapRect, route: route)
			.background(Color.chewFillPrimary)
			.cornerRadius(8)
			.padding(5)
	}
}




struct MapSheet: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var mapRect : MKCoordinateRegion
	let stops : [StopViewData]
	let route : MKPolyline?
	let closeSheet : ()->Void
	var body: some View {
		if #available(iOS 16.0, *) {
			sheet
				.presentationDetents([.medium])
		} else {
			sheet
		}
	}
}

extension MapSheet {
	var sheet : some View {
		NavigationView {
			MapDetailsView(mapRect: mapRect, stops: stops,route: route)
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


struct MapWithCoordinatePickerView: View {
	let type : LocationDirectionType
	@EnvironmentObject var chewVM : ChewViewModel
	let closeSheet : ()->Void
	@State private var selectedCoordinate: CLLocationCoordinate2D? = nil
	@State private var mapCenterCoords: CLLocationCoordinate2D
	init(initialCoords: CLLocationCoordinate2D, type : LocationDirectionType, close : @escaping ()->Void) {
		self.mapCenterCoords = initialCoords
		self.type = type
		self.closeSheet = close
	}
	var body: some View {
		NavigationView {
			MapWithCoordinatePickerUIView(
				selectedCoordinate: $selectedCoordinate,
				mapCenterCoords: $mapCenterCoords
			)
			.overlay(alignment: .bottomLeading) {
				if let selectedCoordinate = selectedCoordinate {
					HStack {
						Text("\(selectedCoordinate.latitude) \(selectedCoordinate.longitude)")
							.padding(5)
							.chewTextSize(.big)
							.frame(maxWidth: .infinity,alignment: .leading)
						Button(action: {
							let stop = Stop(
								coordinates: selectedCoordinate,
								type: .location,
								stopDTO: nil
							)
							chewVM.send(event: .onNewStop(.location(stop), type))
							Model.shared.sheetViewModel.send(event: .didRequestShow(.none))
						}, label: {
							Text("Submit")
								.padding(5)
								.badgeBackgroundStyle(.blue)
								.chewTextSize(.big)
								.foregroundColor(.white)
						})
					}
					.padding(5)
					.badgeBackgroundStyle(.accent)
					.padding(5)
				}
			}
			.padding(5)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Close")
							.foregroundColor(.chewGray30)
					})
				})
			}
		}
	}
}
