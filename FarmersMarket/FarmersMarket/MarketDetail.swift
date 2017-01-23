//
//  MarketDetail.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import ObjectMapper
import Contacts

class MarketDetail: MarketDetailType , Mappable {

	var address: String?
	var products: Array<String>?
	var schedule: String?
	
	required init?(map: Map) {
		
	}
	
//	{"Address":"South Bown Way, Boise, Idaho, 83706","GoogleLink":"http:\/\/maps.google.com\/?q=43.57426%2C%20-116.1549%20(%22East+End+Market+at+Bown+Crossing%22)","Products":"Baked goods; Cheese and\/or dairy products; Crafts and\/or woodworking items; Cut flowers; Eggs; Fresh fruit and vegetables; Fresh and\/or dried herbs; Honey; Canned or preserved fruits, vegetables, jams, jellies, preserves, salsas, pickles, dried fruit, etc.; Meat; Nursery stock, bedding plants; Plants in containers; Poultry; Prepared foods (for immediate consumption); Soap and\/or body care products; Wine, beer, hard cider","Schedule":"May to October sun:10:00 AM - 2:00 PM;<br> <br> <br> "}
	
	func mapping(map: Map) {
		
		address <- map["Address"]

		schedule <- map["Schedule"]
		
		if var toFormat = schedule {
			toFormat = toFormat.replacingOccurrences(of:"<br>", with: "")
			toFormat = toFormat.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
			toFormat = toFormat.trimmingCharacters(in: CharacterSet.init(charactersIn: ";"))
			schedule = toFormat.isEmpty ? nil : toFormat
		}
		
		
		var productsString: String = ""
		productsString <- map["Products"]
		products = productsString.isEmpty ? nil : productsString.components(separatedBy: ";")
	}
	
}
