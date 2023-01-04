//
// Created by Gregorius Albert on 04/01/23.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {

	private let locationManager = CLLocationManager()
	private var authDelegate: LocationAuthorizationProtocol?

	init(viewController: TranscriptionViewController) {
		super.init()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
		locationManager.delegate = self
		authDelegate = viewController
    }

    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        
		// Use the last reported location.
		if let lastLocation = self.locationManager.location {
			let geocoder = CLGeocoder()

			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
				if error == nil {
					let firstLocation = placemarks?[0]
					completionHandler(firstLocation)
				}
				else {
					// An error occurred during geocoding.
					completionHandler(nil)
				}
			})
		}
		else {
			// No location was available.
			completionHandler(nil)
		}
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .authorizedAlways, .authorizedWhenInUse:
			authDelegate?.onAuthorizationChanged()
		default:
			break
		}
	}
}
