//
//  MarketLocation.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import CoreLocation

class MarketLocation: MarketLocationType {

	init(zipCode: String) {
		self.zipCode = zipCode
	}
	
	var zipCode: String?;
	
}
