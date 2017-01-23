//
//  MarketDetailTableViewCell.swift
//  FarmersMarket
//
//  Created by James Burka on 12/14/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit

class MarketDetailTableViewCell: UITableViewCell {

	@IBOutlet var label: UILabel!
	
	func populate(data : MarketDetailData) {
		label.text = data.text
	}


}
