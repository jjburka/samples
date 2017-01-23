//
//  LocationManager.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Swinject
import RxSwift
import RxCocoa
import CoreLocation

class LocationManager: NSObject , LocationManagerType {

	lazy var location: Observable<MarketLocation> = {
		self.manager.rx.didUpdateLocations.flatMap({ (locations) -> Observable<MarketLocation> in
			Observable<MarketLocation>.create({ (observer) -> Disposable in
				let geocoder = CLGeocoder()
				let current = locations.last!
				geocoder.reverseGeocodeLocation(current, completionHandler: { (placeMarkers, error) in
					if error == nil {
						let placeMarker = placeMarkers?.first
						var location = MarketLocation(zipCode: (placeMarker?.postalCode!)!)
						observer.onNext(location)
					} else {
						observer.onError(error!)
					}
				})
				return Disposables.create()
			}).shareReplay(1)
		})
	}()
	
	var container: Container
	var manager: CLLocationManager = CLLocationManager()
	
	init(container: Container) {
		self.container = container
	}
	
	func findCurrentLocation() -> Observable<MarketLocation> {
		// this is janky
		let location = self.location
		manager.requestWhenInUseAuthorization()
		manager.requestLocation()
		return location
	
	}
	
	

	
}
