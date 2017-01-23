//
//  MarketError.swift
//  FarmersMarket
//
//  Created by James Burka on 12/6/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation

struct MarketError : Error {
	
	enum ErrorKind {
		case UnknownZip
		case NotInCache
		case NetworkError
	}
	
	let kind: ErrorKind
	
}
