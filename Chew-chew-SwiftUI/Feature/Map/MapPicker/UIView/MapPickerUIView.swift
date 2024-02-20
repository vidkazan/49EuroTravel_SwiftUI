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

		let gestureRecognizer = UILongPressGestureRecognizer(
			target: context.coordinator,
			action: #selector(Coordinator.handleTap(_:))
		)
		gestureRecognizer.delegate = context.coordinator
		mapView.addGestureRecognizer(gestureRecognizer)
		
		register(mapView)
		return mapView
	}

	private func register(_ mapView : MKMapView){
		StopAnnotation.AnnotationType.allCases.forEach {
			mapView.register(
				StopAnnotationView.self,
				forAnnotationViewWithReuseIdentifier: $0.iconImageName
			)
		}
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		
		if let selectedCoordinate = vm.state.data.selectedStop?.coordinates {
			if let annotation = uiView.annotations.first(where: { $0 is LocationAnnotation }) {
				uiView.removeAnnotation(annotation)
			}
			let annotation = LocationAnnotation()
			annotation.title = vm.state.data.selectedStop?.name
			annotation.coordinate = selectedCoordinate
			uiView.addAnnotation(annotation)
		}
		
		if uiView.region.span.longitudeDelta > 0.02 {
			uiView.removeAnnotations(uiView.annotations.filter({
				$0 is StopAnnotation
			}))
		} else {
			vm.state.data.stops.forEach({ stop in
				if uiView.annotations.first(where: {$0.coordinate == stop.coordinates}) == nil,
				   let annotation = stop.stopAnnotation() {
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
						center: .init(latitude: 51.2, longitude: 6.685),
						latitudinalMeters: 0.02,
						longitudinalMeters: 0.02
					)
				)
			),
			initialCoords: .init(
				latitude: 51.2,
				longitude: 6.685
			),
			type: .departure,
			close: {}
		)
	}
}
