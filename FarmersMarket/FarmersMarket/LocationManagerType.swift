//
//  LocationManagerType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationManagerType {
	
	var location: Observable<MarketLocation> { get }
	
	func findCurrentLocation() -> Observable<MarketLocation>
	
}
