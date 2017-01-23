//
//  MarketSplitViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import Swinject
import RxSwift

class MarketSplitViewController: UISplitViewController , SegueHandlerType {

	var container: Container?
	var disposeBag = DisposeBag()
	var initialMaximumPrimaryColumnWidth: CGFloat?
	var initialMinimumPrimaryColumnWidth: CGFloat?
	
	
	enum SegueIdentifier: String {
		case showLocation
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initialMaximumPrimaryColumnWidth = maximumPrimaryColumnWidth
		initialMinimumPrimaryColumnWidth = minimumPrimaryColumnWidth
		maximumPrimaryColumnWidth = view.bounds.width
		minimumPrimaryColumnWidth = view.bounds.width
		preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let value = segueIdentifierForSegue(segue: segue)
		switch value {
		case .showLocation:
			let controller = segue.destination as! MarketLocationViewController
			controller.container = container
		}
		
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { get {
		let navigationController = viewControllers.last as! UINavigationController
		
		var style = UIStatusBarStyle.default
		
		if let viewController = navigationController.topViewController as? UINavigationController {
			style = viewController.topViewController!.preferredStatusBarStyle
		} else if let viewController = navigationController.topViewController {
			style = viewController.preferredStatusBarStyle
		}
		return style
		}
	
	}
	
	func showDetailView() {
		UIView.animate(withDuration: 0.25, animations: {
			self.maximumPrimaryColumnWidth = self.initialMaximumPrimaryColumnWidth!
			self.minimumPrimaryColumnWidth = self.initialMinimumPrimaryColumnWidth!
			self.preferredDisplayMode = UISplitViewControllerDisplayMode.automatic
		})
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		maximumPrimaryColumnWidth = size.width
		minimumPrimaryColumnWidth = size.width
	
	}

}
