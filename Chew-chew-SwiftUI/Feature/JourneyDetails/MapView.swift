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

struct MapView: View {
	@State var mapRect : MKCoordinateRegion
	var coords : [CLLocationCoordinate2D]
	@ObservedObject var viewModel : JourneyDetailsViewModel
	var body: some View {
		VStack(alignment: .center) {
			Map(coordinateRegion: $mapRect,interactionModes: .all,showsUserLocation: true, annotationItems: coords) { coord in
				MapAnnotation(coordinate: coord) {
					Color.chewRedScale80
						.shadow(radius: 2)
						.cornerRadius(10)
						.frame(width: 20, height: 20)
				}
			}
				.cornerRadius(8)
				.padding(5)
			Button("Close") {
				viewModel.send(event: .didCloseLocationDetails)
			}
				.frame(maxWidth: .infinity,minHeight: 43)
				.background(Color.chewGray15)
				.foregroundColor(.primary)
				.cornerRadius(8)
				.padding(5)
		}
		.font(.system(size: 17,weight: .semibold))
		.background(.ultraThinMaterial)
		.cornerRadius(8)
		.transition(.move(edge: .bottom))
		.opacity(viewModel.state.status.description == "locationDetails" ? 1 : 0)
		.animation(.spring(), value: viewModel.state.status)
	}
}

