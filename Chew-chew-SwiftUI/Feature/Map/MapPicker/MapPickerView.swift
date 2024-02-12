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
	@ObservedObject var vm : MapPickerViewModel
	let closeSheet : ()->Void
	@State private var mapCenterCoords: CLLocationCoordinate2D
	init(vm : MapPickerViewModel,initialCoords: CLLocationCoordinate2D, type : LocationDirectionType, close : @escaping ()->Void) {
		self.mapCenterCoords = initialCoords
		self.type = type
		self.closeSheet = close
		self.vm = vm
	}
	var body: some View {
		NavigationView {
			MapWithCoordinatePickerUIView(
				vm: vm,
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
			if let stop  = vm.state.data.selectedStop {
				HStack {
					Text("\(stop.name)")
						.padding(5)
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,alignment: .leading)
					Button(action: {
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
	@ObservedObject var vm : MapPickerViewModel
	@Binding var mapCenterCoords: CLLocationCoordinate2D
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
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
		return mapView
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		let selectedAnnotationIdentifier = "selectedStop"
		let nearbyStopAnnotationIdentifier = "nearbyStop"
		
		if let selectedCoordinate = vm.state.data.selectedStop?.coordinates {
			if let annotation = uiView.annotations.first(where: { $0.title == selectedAnnotationIdentifier }) {
				uiView.removeAnnotation(annotation)
			}
			let annotation = MKPointAnnotation()
			annotation.title = selectedAnnotationIdentifier
			annotation.coordinate = selectedCoordinate
			uiView.addAnnotation(annotation)
		}
		
		vm.state.data.stops.forEach({ stop in
			if let anno = uiView.annotations.first(where: {
				$0.coordinate == stop.coordinates
			}) {
				return
			}
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = stop.coordinates
			annotation.title = nearbyStopAnnotationIdentifier
			uiView.addAnnotation(annotation)
		})
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
			
			parent.vm.send(event: .didDragMap(mapView.centerCoordinate))
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
			if let coordinate = coordinate {
				parent.vm.send(event: .didTapStopOnMap(Stop(
					coordinates: coordinate,
					type: .location,
					stopDTO: nil
				)))
			}
		}
	}

}
