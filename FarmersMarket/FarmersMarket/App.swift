//
//  App.swift
//  FarmersMarket
//
//  Created by James Burka on 11/28/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import Swinject

class App {
	
	static let sharedInstance = App()
	let container = Container()
	
	init() {
		
	}
	
	func initializeAppereance()  {
		
		
		
		let navigationBarAppearance = UINavigationBar.appearance()
		
		let barTint = UIColor(colorLiteralRed: 109/255.0, green: 130/255.0, blue: 25/255.0, alpha: 1)
		
		navigationBarAppearance.isTranslucent = false
		navigationBarAppearance.barTintColor = barTint
		navigationBarAppearance.tintColor = UIColor.white
		navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
		
		let activityAppearence = UIActivityIndicatorView.appearance()
		
		activityAppearence.color = barTint
		
		
	
	}
	
	func initializeContainer() {
		
		//services
		container.register(NetworkServiceType.self) { _ in  NetworkService()}.inObjectScope(.container)
		container.register(CacheServiceType.self) { _ in  CacheService()}.inObjectScope(.container)

		
		//managers
		container.register(DataManagerType.self) { r in
			//TOOO: figure out why this downcast is needed
			DataManager(container: r as! Container)
			}.inObjectScope(.container)

		container.register(LocationManagerType.self) { r in
			//TOOO: figure out why this downcast is needed
			LocationManager(container: r as! Container)
			}.inObjectScope(.container)
		
		container.register(UserSettingsManagerType.self) { r in
			//TOOO: figure out why this downcast is needed
			UserSettingsManager(container: r as! Container)
			}.inObjectScope(.container)
		
		
		//view models
		container.register(MarketListViewModelType.self) { r in MarketListViewModel(container: r as! Container)}.inObjectScope(.none)
		
		container.register(MarketDetailViewModelType.self) { r in MarketDetailViewModel(container: r as! Container)}.inObjectScope(.none)

		container.register(MarketLocationViewModelType.self) { r in MarketLocationViewModel (container: r as! Container)}.inObjectScope(.none)
		
		
        // figure a way to remove
		container.registerForStoryboard(MarketListViewController.self, initCompleted: { r, c in
			c.container = (r as! Container)
		})
	}
	
	
}
