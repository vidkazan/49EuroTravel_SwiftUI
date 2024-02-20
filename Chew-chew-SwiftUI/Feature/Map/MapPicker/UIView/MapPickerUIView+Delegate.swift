//
//  MapPickerUIView+Coordinator.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.02.24.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI


extension MapPickerUIView {
	class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
		
		var parent: MapPickerUIView
		
		init(parent: MapPickerUIView) {
			self.parent = parent
		}
		
		public func gestureRecognizer(
			_ gestureRecognizer: UIGestureRecognizer,
			shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
		) -> Bool {
			return true
		}
		
		func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
			parent.mapCenterCoords = mapView.centerCoordinate
			parent.vm.send(event: .didDragMap(mapView.region))
		}
		
		func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		}
		
		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let anno = view.annotation as? StopAnnotation {
				if let stop = parent.vm.state.data.stops.first(where: { $0.id == anno.stopId}) {
					parent.vm.send(event: .didTapStopOnMap(stop, send: parent.vm.send))
				}
			}
		}
		
		func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
			if let anno = view.annotation as? StopAnnotation {
				if parent.vm.state.data.stops.first(where: { $0.id == anno.stopId}) != nil {
					parent.vm.send(event: .didDeselectStop)
				}
			}
		}
		
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if let annotation = annotation as? StopAnnotation {
				var annotationView: MKAnnotationView?
				annotationView = setupStopAnnotationView(
					for: annotation,
					mapView: mapView
				)
				return annotationView
			}
			return nil
		}
		
		private func setupStopAnnotationView(for annotation : StopAnnotation, mapView: MKMapView) -> MKAnnotationView? {
			let stopAnnotationView = mapView.dequeueReusableAnnotationView(
				withIdentifier: annotation.type.iconImageName,
				for: annotation
			)
			stopAnnotationView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
			stopAnnotationView.centerOffset = CGPoint(x: 0, y: -stopAnnotationView.frame.size.height / 2)
			stopAnnotationView.canShowCallout = true
			stopAnnotationView.image = UIImage(named: annotation.type.iconImageName)
			return stopAnnotationView
		}
		
		@objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
			if let mapView = gestureRecognizer.view as? MKMapView {
				switch gestureRecognizer.state {
				case .began:
					// disabling zoom, so the didSelect triggers immediately
					let location = gestureRecognizer.location(in: mapView)
					let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
					parent.vm.send(event: .didTapStopOnMap(Stop(
						coordinates: coordinate,
						type: .location,
						stopDTO: nil
					), send: parent.vm.send))
				default:
					break
				}
			}
		}
	}
}
