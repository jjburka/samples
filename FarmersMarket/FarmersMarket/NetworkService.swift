//
//  NetworkService.swift
//  FarmersMarket
//
//  Created by James Burka on 11/18/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxSwift
import Contacts
import CoreLocation

class NetworkService: NetworkServiceType {
	
	let addressFormatter = CNPostalAddressFormatter()
	
	class MarketsResponse : Mappable {
		
		var results: [Market] = []
		var error: Error?
		
		required init?(map: Map) {
			
		}
		
		func mapping(map: Map) {
			results <- map["results"]
			if let result = results.first {
				if result.id == "Error" {
					error = MarketError(kind: .UnknownZip)
					results = []
				}
			}
		}
	}
	
//	{"marketdetails":{"Address":"South Bown Way, Boise, Idaho, 83706","GoogleLink":"http:\/\/maps.google.com\/?q=43.57426%2C%20-116.1549%20(%22East+End+Market+at+Bown+Crossing%22)","Products":"Baked goods; Cheese and\/or dairy products; Crafts and\/or woodworking items; Cut flowers; Eggs; Fresh fruit and vegetables; Fresh and\/or dried herbs; Honey; Canned or preserved fruits, vegetables, jams, jellies, preserves, salsas, pickles, dried fruit, etc.; Meat; Nursery stock, bedding plants; Plants in containers; Poultry; Prepared foods (for immediate consumption); Soap and\/or body care products; Wine, beer, hard cider","Schedule":"May to October sun:10:00 AM - 2:00 PM;<br> <br> <br> "}}
	
	class MarketsDetailResponse : Mappable {
	
		var result: MarketDetail?
		
		required init?(map: Map) {
			
		}
		
		func mapping(map: Map) {
			result <- map["marketdetails"]
		}
		
	}

	func getMarkets(location: MarketLocationType) -> Observable<[MarketType]> {
	
		let result = Observable<[MarketType]>.create { (observer) -> Disposable in
			if let zipCode = location.zipCode {
				let url = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch"
				let parameters: Parameters = ["zip": zipCode]
				Alamofire.request(url , parameters:parameters).responseObject { (response: DataResponse<MarketsResponse>) in
					
					if let value = response.result.value {
						if let error = value.error {
							observer.onError(error)
						} else {
							observer.onNext(value.results)
						
						}
					} else {
						let error = MarketError(kind: .NetworkError)
						observer.onError(error)
					}
					
				}
			}
			return Disposables.create()
		}
		return result.shareReplay(1);
	}
	
	func addressFromPlacemark(placemark:CLPlacemark)->String{
		let address = CNMutablePostalAddress()
		
		if let street = placemark.addressDictionary?["Street"] as? String {
			address.street = street
		}
		
		if let city = placemark.addressDictionary?["City"] as? String {
			address.city = city
		}

		if let zip = placemark.addressDictionary?["ZIP"] as? String {
			address.postalCode = zip
		}
		
		if let state = placemark.addressDictionary?["State"] as? String {
			address.state = state
		}
		
		return addressFormatter.string(from: address)
	}
	
	func getMarketDetail(market: MarketType) -> Observable<MarketDetail> {
		let result = Observable<MarketDetail>.create { (observer) -> Disposable in
			let url = "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail"
			let parameters: Parameters = ["id": market.id]
			Alamofire.request(url , parameters:parameters).responseObject { (response: DataResponse<MarketsDetailResponse>) in
				if let value = response.result.value {
					let coder = CLGeocoder()
					coder.geocodeAddressString((value.result?.address)!, completionHandler: { (placeMarkers, error) in
						if error == nil {
							let placeMark = placeMarkers!.first
							let result = value.result!
							result.address = self.addressFromPlacemark(placemark: placeMark!)
							observer.onNext(value.result!)
						
						} else {
							// if we fail here we really don't care
							// this is just to make the formatting nice
							observer.onNext(value.result!)
						}
						
						
					})
					
					
				} else {
					observer.onError(response.result.error!)
				}
			}
			return Disposables.create()
		}
		return result
	}
	

	
	
}
