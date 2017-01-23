//
//  CacheServiceType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol CacheServiceType {

	func setMarkets(location: MarketLocationType , markets:[MarketType])
	func getMarkets(location: MarketLocationType) -> Observable<[MarketType]>
	
	func getMarketDetail(market: MarketType) -> Observable<MarketDetailType>
	func setMarketDetail(market: MarketType , detail: MarketDetailType)
	
}
