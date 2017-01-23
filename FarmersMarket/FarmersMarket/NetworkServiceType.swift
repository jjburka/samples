//
//  NetworkServiceType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkServiceType {
	
	func getMarkets(location: MarketLocationType) -> Observable<[MarketType]>
	
	func getMarketDetail(market: MarketType) -> Observable<MarketDetail>
	
}
