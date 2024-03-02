//
//  MapDetailsUIView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 22.02.24.
//

import Foundation

import SwiftUI
import OrderedCollections
import MapKit

struct MapDetailsUIView: UIViewRepresentable {
	let legs : OrderedSet<MapLegData>
	let region: MKCoordinateRegion
	
	class Coordinator: NSObject, MKMapViewDelegate {
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = UIColor(Color.chewFillYellowPrimary)
			renderer.lineWidth = 7
			renderer.miterLimit = 1
			renderer.lineJoin = .round
			renderer.lineCap = .round
			return renderer
		}
		
		
		func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			let view = MapPickerViewModel.mapView(mapView, viewFor: annotation)
			if let anno = annotation as? StopAnnotation {
				switch anno.stopOverType {
				case .origin,.destination:
					view?.displayPriority = .required
					view?.zPriority = .defaultUnselected
				case .transfer:
					view?.displayPriority = .required
					view?.zPriority = .max
				case .stopover:
					view?.displayPriority = MKFeatureDisplayPriority(0)
					view?.zPriority = .min
				default:
					view?.displayPriority = MKFeatureDisplayPriority(1)
					view?.zPriority = .min
				}
			}
			return view
		}
	}
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		mapView.region = region
		mapView.showsUserLocation = true
		mapView.userTrackingMode = .followWithHeading
		mapView.isZoomEnabled = true
		mapView.isUserInteractionEnabled = true
		mapView.pointOfInterestFilter = .excludingAll
		
		legs.forEach({ leg in
			leg.stops.forEach { stop in
				MapPickerViewModel.addStopAnnotation(
					id: stop.id,
					lineType: leg.lineType,
					stopName: stop.name,
					coords: stop.locationCoordinates,
					mapView: mapView,
					stopOverType: stop.stopOverType
				)
			}
			if let route = leg.route {
				mapView.addOverlay(route)
			}
		})
		StopAnnotation.registerStopViews(mapView)
		return mapView
	}
	
	
	func updateUIView(_ view: MKMapView, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}
}
