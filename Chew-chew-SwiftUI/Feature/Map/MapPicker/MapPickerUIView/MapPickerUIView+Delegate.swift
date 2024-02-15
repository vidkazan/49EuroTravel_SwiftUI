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
	class Coordinator: NSObject, MKMapViewDelegate {
		var parent: MapPickerUIView

		init(parent: MapPickerUIView) {
			self.parent = parent
		}
		
		func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
			parent.mapCenterCoords = mapView.centerCoordinate
			parent.vm.send(event: .didDragMap(mapView.region))
		}
		
		func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
			if let anno = view.annotation as? StopAnnotation {
				if let stop = parent.vm.state.data.stops.first(where: { $0.id == anno.stopId}) {
					parent.vm.send(event: .didTapStopOnMap(stop, send: parent.vm.send))
				}
			}
			switch view {
			case is BusStopAnnotationView:
				view.layer.cornerRadius = 7
				view.layer.borderWidth = 4
				view.layer.borderColor = UIColor(Color.chewFillAccent).cgColor
			case is UBahnStopAnnotationView:
				view.layer.cornerRadius = 7
				view.layer.borderWidth = 4
				view.layer.borderColor = UIColor(Color.chewFillAccent).cgColor
			case is TrainStopAnnotationView:
				view.layer.cornerRadius = 7
				view.layer.borderWidth = 4
				view.layer.borderColor = UIColor(Color.chewFillAccent).cgColor
			case is TramStopAnnotationView:
				view.layer.cornerRadius = 7
				view.layer.borderWidth = 4
				view.layer.borderColor = UIColor(Color.chewFillAccent).cgColor
			case is SBahnStopAnnotationView:
				view.layer.cornerRadius = 7
				view.layer.borderWidth = 4
				view.layer.borderColor = UIColor(Color.chewFillAccent).cgColor
			default:
				break
			}
		}
		
		func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
			switch view {
			case is UBahnStopAnnotationView:
				view.layer.borderWidth = 0
			case is BusStopAnnotationView:
				view.layer.borderWidth = 0
			case is TrainStopAnnotationView:
				view.layer.borderWidth = 0
			case is TramStopAnnotationView:
				view.layer.borderWidth = 0
			case is SBahnStopAnnotationView:
				view.layer.borderWidth = 0
			default:
				break
			}
		}
		
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if let annotation = annotation as? StopAnnotation {
				switch annotation.type {
				case .bus:
					return mapView.dequeueReusableAnnotationView(withIdentifier: BusStopAnnotationView.reuseIdentifier, for: annotation)
				case .train:
					return mapView.dequeueReusableAnnotationView(withIdentifier: TrainStopAnnotationView.reuseIdentifier, for: annotation)
				case .tram:
					return mapView.dequeueReusableAnnotationView(withIdentifier: TramStopAnnotationView.reuseIdentifier, for: annotation)
				case .ubahn:
					return mapView.dequeueReusableAnnotationView(withIdentifier: UBahnStopAnnotationView.reuseIdentifier, for: annotation)
				case .sbahn:
					return mapView.dequeueReusableAnnotationView(withIdentifier: SBahnStopAnnotationView.reuseIdentifier, for: annotation)
				default:
					return nil
				}
			}
			return nil
		}

		
		@objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
			let mapView = gestureRecognizer.view as? MKMapView

			let location = gestureRecognizer.location(in: mapView)
			let coordinate = mapView?.convert(location, toCoordinateFrom: mapView)
			if let coordinate = coordinate {
				parent.vm.send(event: .didTapStopOnMap(Stop(
					coordinates: coordinate,
					type: .location,
					stopDTO: nil
				), send: parent.vm.send))
			}
		}
	}
}


