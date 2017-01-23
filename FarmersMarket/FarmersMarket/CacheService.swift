//
//  CacheService.swift
//  FarmersMarket
//
//  Created by James Burka on 12/8/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

class CacheService: CacheServiceType {

	var cache = NSCache<AnyObject, AnyObject>()
	
	
	func setMarkets(location: MarketLocationType , markets:[MarketType]) {
		cache.setObject(markets as AnyObject, forKey: location.zipCode! as AnyObject)
	}
	
	func getMarkets(location: MarketLocationType) -> Observable<[MarketType]> {
		return Observable<[MarketType]>.create { (observer) -> Disposable in
			let cached = self.cache.object(forKey: location.zipCode! as AnyObject)
			if let markets = cached as? [MarketType] {
				observer.onNext(markets)
				observer.onCompleted()
			} else {
				observer.onError(MarketError(kind: .NotInCache))
			}
			return Disposables.create()
		}
	}
	
	func getMarketDetail(market: MarketType) -> Observable<MarketDetailType> {
		return Observable<MarketDetailType>.create { (observer) -> Disposable in
			let cached = self.cache.object(forKey: market.id as AnyObject)
			if let market = cached as? MarketDetailType {
				observer.onNext(market)
				observer.onCompleted()
			} else {
				observer.onError(MarketError(kind: .NotInCache))
			}
			return Disposables.create()
		}
	}
	
	func setMarketDetail(market: MarketType , detail: MarketDetailType) {
		cache.setObject(detail as AnyObject, forKey: market.id as AnyObject)
	}



}
