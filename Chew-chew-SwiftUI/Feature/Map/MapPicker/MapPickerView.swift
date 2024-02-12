//
//  MapPickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import SwiftUI
import MapKit


struct MapPickerView: View {
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
			.overlay(alignment: .bottomLeading) { overlay }
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

extension MapPickerView {
	var overlay : some View {
		Group {
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
	}
}

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
