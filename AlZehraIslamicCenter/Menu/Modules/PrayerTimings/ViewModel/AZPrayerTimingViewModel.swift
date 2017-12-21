//
//  AZPrayerTimingViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 03/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZPrayerTimingViewModel {
    
    var prayerTimingAPI: AZPrayerTimingAPI?
    weak var viewController: ViewController?
    var prayerTimingModel: AZPrayerTimingModel?
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchPrayerTimingInfo() {
        
        self.prayerTimingAPI = AZPrayerTimingAPI(type: .fetchPrayerTiming, delegateViewModel: self)
        self.prayerTimingAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
        
    }
}

extension AZPrayerTimingViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if let info = model as? AZPrayerTimingModel {
            self.prayerTimingModel = info
            DispatchQueue.main.async {
                
                self.viewController?.updateView()
            }
        }
        AZProgressView.shared.hideProgressView()
        print("success")
    }
    
    func apiFailure(serviceType: String, error: Error) {
        print("failue")
        AZProgressView.shared.hideProgressView()
    }
    
}
