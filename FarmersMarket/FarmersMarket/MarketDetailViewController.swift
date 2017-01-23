//
//  MarketDetailViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 11/23/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import Swinject
import RxCocoa
import RxSwift
import RxDataSources

class MarketDetailViewController: MarketViewController , MarketErrorViewControllerType {

	var selectedMarket: MarketType?
	var viewModel: MarketDetailViewModelType?
	
	@IBOutlet var tableView: UITableView!
	@IBOutlet var activiyView: UIActivityIndicatorView!
	@IBOutlet var errorTitle: UILabel!
	@IBOutlet var errorDescription: UILabel!
	@IBOutlet var errorView: UIView!
	@IBOutlet var errorButton : UIButton!
	
	
	//MARK: View
	
	func cellIdentifier(item : MarketDetailData) -> String {
	
		var identifier = "detailContentCell"
		
		if item.type == MarketDetailData.DataType.Title {
			identifier = "detailTitleCell"
		} else if item.type == MarketDetailData.DataType.Address {
			identifier = "detailAddressCell"
		}
		return identifier
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = container?.resolve(MarketDetailViewModelType.self)
		
		let dataSource = RxTableViewSectionedReloadDataSource<MarketDetailSectionData>()
		dataSource.configureCell = { dataSource, tableView, indexPath, item in
			let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(item: item)) as! MarketDetailTableViewCell
			cell.populate(data: item)
			return cell
		}
		
		dataSource.titleForHeaderInSection = { dataSource, index in
			return dataSource.sectionModels[index].title
		}
		
		tableView.estimatedRowHeight = 55
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.tableFooterView = UIView()
		viewModel?.marketDetail.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
		tableView.rx.willDisplayCell.asObservable().flatMapFirst { (event) -> Observable<Bool> in
			return Observable<Bool>.just(true)
		}.bindTo(activiyView.rx.isHidden).addDisposableTo(disposeBag)
		
		tableView.rx.modelSelected(MarketDetailData.self).filter { (data) -> Bool in
			return data.type == MarketDetailData.DataType.Address
		}.subscribe(onNext: { (data) in
			self.viewModel?.showMarketLocation(address: data.text)
		}, onError: {error in }, onCompleted: {}, onDisposed: {}).addDisposableTo(disposeBag)
		
		setUpErrorView()
		setupErrorBindings(error: viewModel!.error)
		activiyView.startAnimating()
		
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selected = selectedMarket {
			viewModel?.loadMarketDetail(location: selected)
		}
		
	}

//	//MARK: UITableViewDataSource
//	
//	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return UITableViewAutomaticDimension
//	}
//	
//	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 55
//	}

}
