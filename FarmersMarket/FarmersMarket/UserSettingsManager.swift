//
//  UserSettingsManager.swift
//  FarmersMarket
//
//  Created by James Burka on 11/29/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import RxSwift
import Swinject

class UserSettingsManager: UserSettingsManagerType {

	var locationVariable: Variable<MarketLocationType?>
	var currentLocation: Observable<MarketLocationType>
	
	var setupComplete: Observable<Bool>


	var container: Container
	
	init(container: Container) {
		self.container = container
		locationVariable = Variable<MarketLocationType?>(nil)
		let observable = locationVariable.asObservable()
		currentLocation = observable.debug("currentLocation").filter { (location) -> Bool in
			location != nil
			}.flatMap { (location) -> Observable<MarketLocationType> in
				Observable<MarketLocationType>.just(location!)
		}
		setupComplete = observable.debug("setupComplete").flatMap { (location) -> Observable<Bool> in
			Observable<Bool>.just(location != nil)
		}
	}
	
	func setLocation(location: MarketLocationType?) {
		locationVariable.value = location
	}
	
}
