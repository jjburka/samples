//
//  UserSettingsManagerType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/29/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol UserSettingsManagerType {
	
	var setupComplete: Observable<Bool> {get}
	
	var currentLocation: Observable<MarketLocationType> {get}
	
	func setLocation(location: MarketLocationType?)
	
}
