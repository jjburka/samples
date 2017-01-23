//
//  MarketListViewModelType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

struct MarketErrorData {

	var title: String
	var description: String
	var retryButonText: String
	var retry: () -> ()
}


protocol MarketListViewModelType {
	
	var title: Observable<String> { get }
	var canShowMarkets: Observable<Bool> { get }
	var markets: Observable<[MarketType]> { get }
	var error: Observable<MarketErrorData?> {get }
	
}
