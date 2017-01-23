//
//  MarketListViewModel.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Swinject
import RxSwift

struct MarketCellData  {

	var name: String
	var distance: String
	var id: String
}

class MarketListViewModel: MarketListViewModelType {
	
	var container: Container
	var canShowMarkets: Observable<Bool>
	var title: Observable<String>
	var markets: Observable<[MarketType]>
	var error: Observable<MarketErrorData?>
	
	init(container : Container) {
		self.container = container;
		let manager = container.resolve(UserSettingsManagerType.self)!
		canShowMarkets = manager.setupComplete
		
		let errorVariable = Variable<MarketErrorData?>(nil)
		error = errorVariable.asObservable()
		
		
		markets = canShowMarkets.debug("markets").filter { (canShow) -> Bool in
					canShow
		}.flatMap { (canShow) -> Observable<MarketLocationType> in
			let manager = container.resolve(UserSettingsManagerType.self)
			return manager!.currentLocation
		}.flatMap { (location) -> Observable<[MarketType]> in
			let manager = container.resolve(DataManagerType.self)
			// the catch error needs to be on the inner observable so the exposed one doesn't error out. this seems wrong
			return manager!.markets(location: location).catchError({ (error) -> Observable<[MarketType]> in
				if let marketError = error as? MarketError {
					switch marketError.kind {

					case .UnknownZip :
						let value = MarketErrorData(title: "No Results", description: "Could not find any markets", retryButonText:"Change Zip") { ()in
							let manager = container.resolve(UserSettingsManagerType.self)
							manager?.setLocation(location: nil)
							errorVariable.value = nil

						}
						errorVariable.value = value
					case .NetworkError :
						let value = MarketErrorData(title: "Network Issue", description: "Could not connect to find markets", retryButonText:"Retry") { ()in
							let manager = container.resolve(UserSettingsManagerType.self)
							manager?.setLocation(location: nil)
							errorVariable.value = nil
							
						}
						errorVariable.value = value
					default :
						let value = MarketErrorData(title: "Unknown Error", description: "Something went wrong :(", retryButonText:"Retry") { ()in
							let manager = container.resolve(UserSettingsManagerType.self)
							manager?.setLocation(location: nil)
							errorVariable.value = nil
							
						}
						errorVariable.value = value
						
					}
				}
				return Observable<[MarketType]>.just([])
			})
		}
		
		title = canShowMarkets.filter{ (canShow) -> Bool in
			canShow
		}.flatMap { (canShow) -> Observable<MarketLocationType> in
			let manager = container.resolve(UserSettingsManagerType.self)
			return manager!.currentLocation
		}.flatMap { (location) -> Observable<String> in
			Observable<String>.just("Markets near \(location.zipCode!)")
		}
	}
	
}





