//
//  MarketListTableViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import RxCocoa
import Mixpanel

class MarketListViewController: MarketViewController, SegueHandlerType , MarketErrorViewControllerType {


	enum SegueIdentifier: String {
		case showDetail
		case showLocation
		case showError
	}
	
	var viewModel: MarketListViewModelType?
	var selectedMarket: MarketType?  // get rid off
	
	@IBOutlet var tableView: UITableView!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var activiyView: UIActivityIndicatorView!
	@IBOutlet var errorTitle: UILabel!
	@IBOutlet var errorDescription: UILabel!
	@IBOutlet var errorView: UIView!
	@IBOutlet var errorButton : UIButton!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	//MARK: Bindings
	

	
	private func setupTableViewBindings() {
		viewModel?.markets.bindTo(tableView.rx.items(cellIdentifier: "MarketTableViewCell")) {
			index, market, cell in
			
			if let current = cell as? MarketTableViewCell {
				current.populate(market: market)
			}
			
			}.addDisposableTo(disposeBag)
		
		
		
		tableView.rx.modelSelected(MarketType.self).subscribe(onNext: { model in
			Mixpanel.mainInstance().track(event: "marketSelected",
			                              properties: ["market" : model.id])
			self.selectedMarket = model
			self.performSegue(withIdentifier: .showDetail, sender: nil)
		}).addDisposableTo(disposeBag)
		
		tableView.rx.willDisplayCell.asObservable().flatMapFirst { (event) -> Observable<Bool> in
			if let controller = self.splitViewController as? MarketSplitViewController {
				if !controller.isCollapsed {
					controller.showDetailView()
				}
			}
			return Observable<Bool>.just(true)
			}.bindTo(activiyView.rx.isHidden).addDisposableTo(disposeBag)
	}
	
	private func setupBindings() {
		viewModel?.canShowMarkets.bindTo(activiyView.rx.isAnimating).addDisposableTo(disposeBag)
		viewModel?.canShowMarkets.subscribe(onNext: { (canShow) in
			self.imageView.isHidden = canShow
			self.navigationController?.isNavigationBarHidden = !canShow
		}, onError: { (error) in }, onCompleted: {}, onDisposed: {}).addDisposableTo(disposeBag)
		
		
		viewModel?.title.bindTo(rx.title).addDisposableTo(disposeBag)
		
		
		viewModel?.canShowMarkets.flatMap({ (canShow) -> Observable<Bool> in
			return Observable<Bool>.just(canShow == false)
		}).bindTo(activiyView.rx.isHidden).addDisposableTo(disposeBag)
		
		setupTableViewBindings()
		setupErrorBindings(error: viewModel!.error)
	
	}
	
	//MARK: View setup
	
	private func setupTableView() {
		tableView.dataSource = nil
		tableView.delegate = nil
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.tableFooterView = UIView()
	}
	
	//MARK: View
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = container!.resolve(MarketListViewModelType.self)
		setupTableView()
		setUpErrorView()
		setupBindings()
		view.bringSubview(toFront: imageView)
		navigationController?.isNavigationBarHidden = true
		
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedIndexPath, animated: true)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// should be in a view model
		let manager = container?.resolve(UserSettingsManagerType.self)
		manager?.setupComplete.subscribe(onNext: { (setupComplete) in
			// this seems to fire twice sometimes
			if(setupComplete == false) {
				self.performSegue(withIdentifier: .showLocation, sender: nil)
			}
		}, onError: {error in}, onCompleted: {}, onDisposed: {}).addDisposableTo(disposeBag)
	}

	//MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let toShow = segueIdentifierForSegue(segue: segue)
		switch toShow {
		case .showDetail:
			let controller = (segue.destination as! UINavigationController).topViewController as! MarketDetailViewController
			controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
			controller.navigationItem.leftItemsSupplementBackButton = true
			controller.selectedMarket = self.selectedMarket
			controller.container = self.container
		case .showLocation:
			let controller = segue.destination as! MarketLocationViewController
			controller.container = container
		case .showError:
			break
		}
	}
	
	@IBAction func showZipCodeWasPressed() {
		self.performSegue(withIdentifier: .showLocation, sender: nil)
	}

}
