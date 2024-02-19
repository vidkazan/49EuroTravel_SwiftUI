//
//  LocationManager.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 14.09.23.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
	var locationManager = CLLocationManager()
	@Published var authorizationStatus: CLAuthorizationStatus?
	
	override init() {
		super.init()
		locationManager.delegate = self
	}
	
	func reverseGeocoding(coords : CLLocationCoordinate2D) async -> String? {
		if self.locationManager.location != nil,
		   let res = try? await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coords.latitude, longitude: coords.longitude)).first,
			let name = res.name, let city = res.locality {
				return  String(name + ", " + city)
		}
		return nil
	}
	
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .authorizedWhenInUse:  // Location services are available.
			// Insert code here of what should happen when Location services are authorized
			authorizationStatus = .authorizedWhenInUse
			locationManager.requestLocation()
			break
			
		case .restricted:  // Location services currently unavailable.
			// Insert code here of what should happen when Location services are NOT authorized
			authorizationStatus = .restricted
			break
			
		case .denied:  // Location services currently unavailable.
			// Insert code here of what should happen when Location services are NOT authorized
			authorizationStatus = .denied
			break
			
		case .notDetermined:        // Authorization not determined yet.
			authorizationStatus = .notDetermined
			manager.requestWhenInUseAuthorization()
			break
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		#warning("locatons updates are not handling?")
		//		 Insert code to handle location updates
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error: \(error.localizedDescription)")
	}
}
