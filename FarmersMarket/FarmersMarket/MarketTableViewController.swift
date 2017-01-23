//
//  MarketTableViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 11/29/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Swinject

class MarketTableViewController: UITableViewController {

	internal var container: Container?
	internal var disposeBag = DisposeBag()
	
	override var preferredStatusBarStyle: UIStatusBarStyle { get {
		return UIStatusBarStyle.lightContent
		}
	}

}
