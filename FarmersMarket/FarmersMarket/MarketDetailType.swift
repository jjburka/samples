//
//  MarketDetailType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import Contacts



protocol MarketDetailType {
	
	var address: String? {get set}
	var products: Array<String>? {get set}
	var schedule: String? {get set}

}
