//
//  MarkerManagerType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol DataManagerType {

	func markets(location: MarketLocationType) -> Observable<[MarketType]>
	
	func marketDetail(market: MarketType) -> Observable<MarketDetailType>;
	
}
