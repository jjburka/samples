//
//  MarketDetailViewModel.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Swinject
import RxSwift
import RxCocoa
import Contacts

class MarketDetailViewModel: MarketDetailViewModelType {

	var container: Container
	var disposeBag: DisposeBag = DisposeBag()
	
	var market: Variable<MarketType?>
	var error: Observable<MarketErrorData?>
	
	private (set) var marketDetail: Observable<[MarketDetailSectionData]>
	
	init(container : Container) {
		self.container = container
		
		let errorVariable = Variable<MarketErrorData?>(nil)
		error = errorVariable.asObservable()
		market = Variable<MarketType?>(nil)
		let manager = container.resolve(DataManagerType.self)!
		marketDetail =  market.asObservable().filter { (market) -> Bool in
			market != nil
			}.flatMap { (market) -> Observable<(MarketType,MarketDetailType)> in
				return Observable.zip(Observable<MarketType>.just(market!), manager.marketDetail(market: market!)) {
					return ($0,$1)
				}
			}.flatMap { (market, details) -> Observable<[MarketDetailSectionData]> in
				
				var sections : [MarketDetailSectionData] = []
				var section = MarketDetailSectionData(title: nil, items: [])
				
				section.items.append(MarketDetailData(text: market.name, type: .Title))
				
				if let address = details.address {
					section.items.append(MarketDetailData(text: address, type: .Address))
				}
				sections.append(section)
				if let products = details.products {
					section = MarketDetailSectionData(title: "Products", items: [])
					let formatedDetails = products.map({ (product) -> String in
						"- \(product.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))"
					})
					section.items.append(MarketDetailData(text: formatedDetails.joined(separator: "\n"), type: .Products))
					sections.append(section)
				}
				if let products = details.schedule {
					section = MarketDetailSectionData(title: "Schedule", items: [])
					section.items.append(MarketDetailData(text: products, type: .Products))
					sections.append(section)
				}
				return Observable<[MarketDetailSectionData]>.just(sections)
		}
	}
	
	func showMarketLocation(address: String) {
		let escaped  = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let urlString = "http://maps.apple.com/?address=\(escaped! as String)"
		if let url = URL(string: urlString) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	func loadMarketDetail(location: MarketType) {
		market.value = location
	}

	
	
}
