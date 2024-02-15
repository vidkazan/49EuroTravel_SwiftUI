//
//  MapPickerUIView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.02.24.
//

import Foundation
import SwiftUI
import MapKit

struct MapPickerUIView: UIViewRepresentable {
	@ObservedObject var vm : MapPickerViewModel
	var mapCenterCoords: CLLocationCoordinate2D
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		mapView.showsUserLocation = true
		let initialLocation = mapCenterCoords
		
		let span = MKCoordinateSpan(
			latitudeDelta: 0.01,
			longitudeDelta: 0.01
		)
		let region = MKCoordinateRegion(center: initialLocation, span: span)
		mapView.setRegion(region, animated: true)

		let gestureRecognizer = UITapGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.handleTap(_:))
		)
		mapView.addGestureRecognizer(gestureRecognizer)
		register(mapView)
		return mapView
	}

	func register(_ mapView : MKMapView){
		mapView.register(
			BusStopAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: BusStopAnnotationView.reuseIdentifier
		)
		mapView.register(
			TrainStopAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: TrainStopAnnotationView.reuseIdentifier
		)
		mapView.register(
			SBahnStopAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: SBahnStopAnnotationView.reuseIdentifier
		)
		mapView.register(
			TramStopAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: TramStopAnnotationView.reuseIdentifier
		)
		mapView.register(
			UBahnStopAnnotationView.self,
			forAnnotationViewWithReuseIdentifier: UBahnStopAnnotationView.reuseIdentifier
		)
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		let selectedAnnotationIdentifier = "selectedStop"


		// select annotation
		if let selectedCoordinate = vm.state.data.selectedStop?.coordinates {
			if let annotation = uiView.annotations.first(where: { $0.title == selectedAnnotationIdentifier }) {
				uiView.removeAnnotation(annotation)
			}
			let annotation = MKPointAnnotation()
			annotation.title = selectedAnnotationIdentifier
			annotation.coordinate = selectedCoordinate
			uiView.addAnnotation(annotation)
		}
		
		
		// stops annotation
		if uiView.region.span.longitudeDelta > 0.02 {
			uiView.removeAnnotations(uiView.annotations.filter({
				$0 is StopAnnotation
			}))
		} else {
			vm.state.data.stops.forEach({ stop in
				if let anno = uiView.annotations.first(where: {
					$0.coordinate == stop.coordinates
				}) {
					return
				}
				
				if let annotation = stop.stopAnnotation() {
					uiView.addAnnotation(annotation)
				}
			})
		}
	}
}

struct MyPreviewProvider_Previews: PreviewProvider {
	static var previews: some View {
		MapPickerView(
			vm: .init(
				.loadingNearbyStops(.init(
						center: .init(latitude: 51.2, longitude: 6.6),
						latitudinalMeters: 0.02,
						longitudinalMeters: 0.02
					)
				)
			),
			initialCoords: .init(
				latitude: 51.2,
				longitude: 6.6
			),
			type: .departure,
			close: {}
		)
	}
}
