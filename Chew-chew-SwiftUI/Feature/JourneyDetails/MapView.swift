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


// TODO: routing https://www.hackingwithswift.com/example-code/location/how-to-find-directions-using-mkmapview-and-mkdirectionsrequest
struct MapView: View {
	@State var mapRect : MKCoordinateRegion
	let coords : [CLLocationCoordinate2D]
	var body: some View {
		Map(coordinateRegion: $mapRect,interactionModes: .all,showsUserLocation: true, annotationItems: coords) { coord in
			MapAnnotation(coordinate: coord) {
				Color.chewRedScale80
					.shadow(radius: 2)
					.cornerRadius(10)
					.frame(width: 20, height: 20)
			}
		}
		.background(Color.chewGray15)
		.cornerRadius(8)
		.padding(5)
	}
}


struct MapSheet: View {
	@ObservedObject var viewModel : JourneyDetailsViewModel
	var body: some View {
		VStack(alignment: .center,spacing: 0) {
			Label("Map", systemImage: "map.circle")
				.chewTextSize(.big)
				.padding(10)
			switch viewModel.state.status {
			case .loadingLocationDetails:
				Spacer()
				ProgressView()
				Spacer()
			case .locationDetails(coordRegion: let reg, coordinates: let coords):
				MapView(mapRect: reg, coords: coords)
			case .error,.loadedJourneyData,.loading,.fullLeg,.loadingFullLeg,.actionSheet:
				Spacer()
			}
			Spacer()
			Button("Close") {
				viewModel.send(event: .didCloseBottomSheet)
			}
			.frame(maxWidth: .infinity,minHeight: 43)
			.background(Color.chewGray15)
			.foregroundColor(.primary)
			.cornerRadius(8)
			.padding(5)
		}
		.chewTextSize(.big)
		.background(Color.chewGrayScale07)
	}
}

