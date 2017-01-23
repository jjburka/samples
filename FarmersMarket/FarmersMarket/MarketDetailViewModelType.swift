//
//  MarketDetailViewModelType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

struct MarketDetailData {
	
	enum DataType  {
		case Title
		case Address
		case Hours
		case Products
	
	}
	
	var text: String!
	var type: DataType!
	
}

struct MarketDetailSectionData :SectionModelType {
	
	typealias Item = MarketDetailData
	var title: String?
	var items: [MarketDetailData]

	init(title: String?, items: [MarketDetailData]) {
		self.title = title
		self.items = items
	}
	
	init(original: MarketDetailSectionData, items: [MarketDetailData]) {
		self = original
		self.title = original.title
		self.items = items
	}
	
}

protocol MarketDetailViewModelType  {
	
	var error: Observable<MarketErrorData?> {get}
	var marketDetail: Observable<[MarketDetailSectionData]> {get}
	func loadMarketDetail(location: MarketType);
	func showMarketLocation(address: String)
	
}
