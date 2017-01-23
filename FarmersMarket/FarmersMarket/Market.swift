//
//  Market.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import ObjectMapper

class Market: MarketType , Mappable {

	var name: String = ""
	var distance: String = ""
	var id: String = ""
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		//{"id":"1003629","marketname":"1.8 East End Market at Bown Crossing"}
		id <- map["id"]
		var marketname: String = ""
		marketname <- map["marketname"]
		
		var components = marketname.components(separatedBy: " ")
		
		distance = components.first!
		components.remove(at: 0)
		
		name = components.joined(separator: " ")
	}
	
	
}
