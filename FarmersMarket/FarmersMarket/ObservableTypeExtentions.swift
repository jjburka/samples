//
//  ObservableTypeExtentions.swift
//  FarmersMarket
//
//  Created by James Burka on 12/7/16.
//  Copyright © 2016 James Burka. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {


	public func catchErrorAndContinue(_: @escaping (Error) throws -> Void) -> RxSwift.Observable<Self.E> {
		return self.catchError { error in
			try handler(error)
			return Observable.error(error)
			}.retry()
	}

}



