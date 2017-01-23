//
//  MarketTableViewCell.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit

class MarketTableViewCell: UITableViewCell {

	@IBOutlet var market: UILabel!
	@IBOutlet var distance: UILabel!
	
	func populate(market: MarketType)  {
		
		self.market.text = market.name
		distance.text = "\(market.distance) mi"
		
	}

}
