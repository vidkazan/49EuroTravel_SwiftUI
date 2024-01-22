//
//  MapView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.10.23.
//

import Foundation
import MapKit
import SwiftUI

extension CLLocationCoordinate2D: Identifiable {
	public var id: String {
		"\(latitude)-\(longitude)"
	}
}

struct MapUIView: UIViewRepresentable {
	let stops : [StopViewData]
	let region: MKCoordinateRegion
	let route : MKPolyline?
	
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

	// We don't need to worry about this as the view will never be updated.
	func updateUIView(_ view: MKMapView, context: Context) {}

	// Link it to the coordinator which is defined below.
	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

}

class Coordinator: NSObject, MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		renderer.strokeColor = UIColor.white
		renderer.lineWidth = 5
		return renderer
	}
}

struct MapView: View {
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
	@ObservedObject var viewModel : JourneyDetailsViewModel
	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 0) {
				switch viewModel.state.status {
				case .loadingLocationDetails:
					Spacer()
					ProgressView()
					Spacer()
				case .locationDetails(coordRegion: let reg, stops: let stops, let route):
					MapView(mapRect: reg, stops: stops,route: route)
				case .error,
					.loadedJourneyData,
					.loading,
					.fullLeg,
					.loadingFullLeg,
					.actionSheet,
					.changingSubscribingState,
					.loadingIfNeeded:
					Spacer()
				}
			}
			.navigationTitle("Map")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						viewModel.send(event: .didCloseBottomSheet)
					}
				})
			}
		}
	}
}

