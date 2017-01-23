//
//  DataManager.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Swinject
import RxSwift

class DataManager: DataManagerType {

	var container: Container
	
	init(container: Container) {
		self.container = container
	}
	
	func markets(location: MarketLocationType) -> Observable<[MarketType]> {
		let network = container.resolve(NetworkServiceType.self)!
		let cache = container.resolve(CacheServiceType.self)!
		
		// hit the cache first on error get it from the network
		return cache.getMarkets(location: location).catchError { (error) -> Observable<[MarketType]> in
			return network.getMarkets(location: location).flatMap{ (markets) -> Observable<[MarketType]> in
				cache.setMarkets(location: location, markets: markets)
				return Observable<[MarketType]>.just(markets)
			}
		}.subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)).observeOn(MainScheduler.instance)
	}
	
	func marketDetail(market: MarketType) -> Observable<MarketDetailType> {
		let network = container.resolve(NetworkServiceType.self)!
		let cache = container.resolve(CacheServiceType.self)!

		return cache.getMarketDetail(market: market).catchError({ (error) -> Observable<MarketDetailType> in
			return network.getMarketDetail(market: market).flatMap({ (detail) -> Observable<MarketDetailType> in
				cache.setMarketDetail(market: market, detail: detail)
				return Observable<MarketDetailType>.just(detail)
			})
		}).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)).observeOn(MainScheduler.instance)
	}

	
	
}
