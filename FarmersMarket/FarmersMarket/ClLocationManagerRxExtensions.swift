//
//  ClLocationManagerRxExtensions.swift
//  FarmersMarket
//
//  Created by James Burka on 11/29/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class CLLocationManagerDelegateProxy: DelegateProxy, CLLocationManagerDelegate, DelegateProxyType {
	
	static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
		let manager = object as! CLLocationManager
		return manager.delegate
	}
	//We need a way to set the current delegate
	static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
		let manager = object as! CLLocationManager
		manager.delegate = delegate as? CLLocationManagerDelegate
	}
	
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		
	}
	
}

extension Reactive where Base: CLLocationManager {
	
	public var delegate: DelegateProxy {
		return CLLocationManagerDelegateProxy.proxyForObject(self.base)
	}
	
	public var didUpdateLocations: Observable<[CLLocation]> {
		return delegate.rx.sentMessage(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))).map { params in
			params.last as! [CLLocation]
		}
	}

	public var didFailWithError: Observable<Error> {
		return delegate.rx.sentMessage(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:))).map { params in
			params.last as! Error
		}
	}
	
}

