//
//  SegueHandlerType.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import UIKit

protocol SegueHandlerType {
	associatedtype SegueIdentifier: RawRepresentable
}

// stolen from WWDC
extension SegueHandlerType where Self: UIViewController,
	SegueIdentifier.RawValue == String
{
	
	func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
		
		performSegue(withIdentifier: identifier.rawValue, sender: sender)
	}
	
	func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
		
		// still have to use guard stuff here, but at least you're
		// extracting it this time
		guard let identifier = segue.identifier,
			let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
				fatalError("Invalid segue identifier \(segue.identifier).") }
		
		return segueIdentifier
	}
}
