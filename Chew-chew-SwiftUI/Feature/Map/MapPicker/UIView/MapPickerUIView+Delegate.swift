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
			print(">>> here")
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
				switch annotation.type {
				case .bus:
					return mapView.dequeueReusableAnnotationView(
						withIdentifier: BusStopAnnotationView.reuseIdentifier,
						for: annotation
					) as? BusStopAnnotationView
				case .train:
					return mapView.dequeueReusableAnnotationView(
						withIdentifier: TrainStopAnnotationView.reuseIdentifier,
						for: annotation
					) as? TrainStopAnnotationView
				case .tram:
					return mapView.dequeueReusableAnnotationView(
						withIdentifier: TramStopAnnotationView.reuseIdentifier,
						for: annotation
					) as? TramStopAnnotationView
				case .ubahn:
					return mapView.dequeueReusableAnnotationView(
						withIdentifier: UBahnStopAnnotationView.reuseIdentifier,
						for: annotation
					) as? UBahnStopAnnotationView
				case .sbahn:
					return mapView.dequeueReusableAnnotationView(
						withIdentifier: SBahnStopAnnotationView.reuseIdentifier,
						for: annotation
					) as? SBahnStopAnnotationView
				default:
					return nil
				}
			}
			return nil
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
