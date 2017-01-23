//
//  MarketLocationViewModel.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift
import Swinject

class MarketLocationViewModel: MarketLocationViewModelType {

	private (set) var isValid: Observable<Bool>
	private (set) var zipCode: Variable<String?>
	var disposeBag = DisposeBag()
	var container: Container
	private (set) var canContinue: Variable<Bool>
	
	init(container : Container) {
		self.container = container;
		canContinue = Variable<Bool>(false)
		zipCode = Variable<String?>(nil)
		isValid = zipCode.asObservable().flatMap({ (zipCode) -> Observable<Bool> in
			return Observable<Bool>.create({ (observer) -> Disposable in

				if let zip = zipCode {
					observer.onNext(zip.characters.count >= 5)
				} else {
					observer.onNext(false)
				}
				return Disposables.create()
			})
		})
	}
	
	func findLocation() {
		let locationManager = container.resolve(LocationManagerType.self)!
		locationManager.findCurrentLocation().subscribe(onNext: { (location) in
			self.selectZipCode(zipCode: location.zipCode!)
		}, onError: {error in }, onCompleted: { }, onDisposed: { }).addDisposableTo(disposeBag)
		canContinue.value = true
	}
	
	func selectZipCode() {
		selectZipCode(zipCode: zipCode.value!)
	}
	
	private func selectZipCode(zipCode: String) {
		let manager = container.resolve(UserSettingsManagerType.self)
		manager?.setLocation(location: MarketLocation(zipCode: zipCode))
		canContinue.value = true
	}
	
	
}
