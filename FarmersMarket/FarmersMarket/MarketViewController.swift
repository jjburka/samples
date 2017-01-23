//
//  MarketViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 12/1/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import RxSwift
import Swinject

protocol MarketErrorViewControllerType {
	
	var errorTitle: UILabel! {get}
	var errorDescription: UILabel! {get}
	var errorView: UIView! {get}
	var errorButton: UIButton! {get}
	var disposeBag: DisposeBag {get}
}

extension MarketErrorViewControllerType {
	
	func setupErrorBindings(error :Observable<MarketErrorData?>) {
		error.flatMap({ (error) -> Observable<Bool> in
			return Observable<Bool>.just(error == nil)
		}).bindTo(errorView.rx.isHidden).addDisposableTo(disposeBag)
		
		error.flatMap({ (error) -> Observable<String?> in
			return Observable<String?>.just(error?.title)
		}).bindTo(errorTitle.rx.text).addDisposableTo(disposeBag)
		
		error.flatMap({ (error) -> Observable<String?> in
			return Observable<String?>.just(error?.description)
		}).bindTo(errorDescription.rx.text).addDisposableTo(disposeBag)
		
		
		error.flatMap({ (error) -> Observable<String?> in
			return Observable<String?>.just(error?.retryButonText)
		}).bindTo(errorButton.rx.title()).addDisposableTo(disposeBag)
		
		
		error.flatMap({ (error) -> Observable<Bool> in
			return Observable<Bool>.just(error == nil)
		}).bindTo(errorButton.rx.isHidden).addDisposableTo(disposeBag)
		
		let retry = error.map({ (error) -> () -> () in
			var toReturn: () -> ()
			if let retry = error?.retry {
				toReturn = retry
			} else {
				toReturn = { }
			}
			return toReturn
		})
		
		let errorObserver = errorButton.rx.tap.asObservable()
		errorObserver.flatMap { () -> Observable<()->()> in
			return retry
			}.subscribe(onNext: { (errorBlock) in
				errorBlock()
			}, onError: {error in}, onCompleted: {}, onDisposed: {}).addDisposableTo(disposeBag)
	}
	
	func setUpErrorView() {
		errorView.isHidden = true
		errorView.layer.borderColor = errorButton.backgroundColor?.cgColor
		errorView.layer.borderWidth = 4
		errorView.layer.cornerRadius = 10
		errorView.clipsToBounds = true
	}
	
	
}

class MarketViewController: UIViewController {
	
	
	internal var container: Container? = App.sharedInstance.container
	internal var disposeBag = DisposeBag()

	override var preferredStatusBarStyle: UIStatusBarStyle { get {
		return UIStatusBarStyle.lightContent
		}
	}
	
}
