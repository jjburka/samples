//
//  MarketLocationViewModelType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

protocol MarketLocationViewModelType {
	
	var isValid: Observable<Bool> {get}
	var zipCode: Variable<String?> {get}
	var canContinue: Variable<Bool> {get}
	
	func findLocation()
	func selectZipCode();
	
}
