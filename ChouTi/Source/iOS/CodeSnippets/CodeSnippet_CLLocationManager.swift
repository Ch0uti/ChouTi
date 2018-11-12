//
//  Created by Honghao Zhang on 12/13/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

//import CoreLocation

// Simulating Locations with Xcode: https://blackpixel.com/writing/2013/05/simulating-locations-with-xcode.html
// GPX: http://gpx-poi.com

// On iOS8, to request location permission:
// In info.plist
// NSLocationAlwaysUsageDescription = "App use Locations service mode Always" (Explanations)
// NSLocationWhenInUseUsageDescription = "App use Locations service mode In Use" (Explanations)

//let locationManager = CLLocationManager()
//locationManager.delegate = self
//locationManager.desiredAccuracy = kCLLocationAccuracyBest
//locationManager.requestWhenInUseAuthorization()
//locationManager.startUpdatingLocation()

//extension <#ViewController#> : CLLocationManagerDelegate {
//	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		locationManager.stopUpdatingLocation()
//		guard let currentLocation = locations.last else {
//			NSLog("Error: get currentLocation failed")
//			return
//		}
//		
//		CLGeocoder().reverseGeocodeLocation(currentLocation) { [unowned self] (placemarks, error) -> Void in
//			if let error = error {
//				NSLog("Error: Reverse geocoder failed with error: \(error.localizedDescription)")
//				return
//			}
//			
//			let firstPlace = placemarks?.first
//			let streetNumber = firstPlace?.subThoroughfare
//			let streetName = firstPlace?.thoroughfare
//			
//			self.addressField.text = (streetNumber != nil ? "\(streetNumber!) " : "") + "\(streetName ?? "")"
//			
//			self.cityField.text = firstPlace?.locality ?? firstPlace?.subLocality ?? firstPlace?.subAdministrativeArea ?? firstPlace?.administrativeArea ?? ""
//		}
//	}
//	
//	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//		NSLog("Error: locationManager didFailWithError:" + error.localizedDescription)
//	}
//}
