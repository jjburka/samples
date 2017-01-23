//
//  MarketLocationTableViewController.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Swinject

class MarketLocationViewController: MarketViewController {

	var viewModel: MarketLocationViewModelType?
	
	@IBOutlet var zip: UITextField!
	@IBOutlet var location: UIButton!
	@IBOutlet var go: UIButton!
	@IBOutlet var constraint: NSLayoutConstraint!
	@IBOutlet var containerView: UIView!
	
	//MARK: Bindings
	
	deinit {
		
	}
	
	private func setupNotificationBindings() {
		// not sure if rxwift will handle this correctly. we might need to save the disposeable and call
		// dispose() on viewDidDisappear
		NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow).subscribe(
			onNext: { (notification) in
				self.updateZipView(notification: notification)
		},
			onError: {error in},
			onCompleted: {}, onDisposed: {}
			).addDisposableTo(disposeBag)
		
		NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide).subscribe(
			onNext: { (notification) in
				self.updateZipView(notification: notification)
		},
			onError: {error in},
			onCompleted: {},
			onDisposed: {}
			).addDisposableTo(disposeBag)
	
	}
	
	private func setupFormBindings() {
		viewModel?.zipCode.asObservable().bindTo(zip.rx.text).addDisposableTo(disposeBag)
		
		let observable = zip.rx.text.asObservable()
		
		observable.bindTo((viewModel?.zipCode)!).addDisposableTo(disposeBag)
		
		viewModel?.isValid.bindTo(go.rx.isEnabled).addDisposableTo(disposeBag)
		
		let tapObservable = go.rx.tap.asObservable()
		tapObservable.subscribe { (event) in
			self.zip.resignFirstResponder()
			self.viewModel?.selectZipCode()
			}.addDisposableTo(disposeBag)
		
		let locationObservable = location.rx.tap.asObservable()
		locationObservable.subscribe { (event) in
			self.viewModel?.findLocation()
			}.addDisposableTo(disposeBag)
		
		viewModel?.canContinue.asObservable().subscribe({ (event) in
			if(event.element == true) {
				let size = self.containerView.bounds.size
				self.constraint.constant = -size.height
				UIView.animate(withDuration: 0.25,
				               delay: TimeInterval(0),
				               options: UIViewAnimationOptions.curveEaseIn,
				               animations: { self.view.layoutIfNeeded() })
				{ completed in
					self.dismiss(animated: false, completion: nil)
				}
				
			}
		}).addDisposableTo(disposeBag)
	
	}
	
	private func setupBindings() {
		setupFormBindings()
		setupNotificationBindings()
	}
	
	//MARK: Keyboard Handling
	
	private func updateZipView(notification : Notification)  {
		if let userInfo = notification.userInfo {
			let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
			let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
			let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
			let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
			let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
			
			// if we are off the screen
			if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
				self.constraint?.constant = 0.0
			} else {
				self.constraint?.constant = (endFrame?.size.height)!
			}
			UIView.animate(withDuration: duration,
			               delay: TimeInterval(0),
			               options: animationCurve,
			               animations: { self.view.layoutIfNeeded() },
			               completion: nil)
		}
	}
	
	//MARK: View
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewModel = container?.resolve(MarketLocationViewModelType.self)
		setupBindings()
		containerView.layer.borderColor = go.backgroundColor?.cgColor
		containerView.layer.borderWidth = 4
		
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let size = containerView.bounds.size
		
		constraint.constant = -size.height
		view.updateConstraints()
		constraint?.constant = 0.0
		UIView.animate(withDuration: 0.25,
		               delay: TimeInterval(0),
		               options: UIViewAnimationOptions.curveEaseIn,
		               animations: { self.view.layoutIfNeeded() },
		               completion: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
	}
}
