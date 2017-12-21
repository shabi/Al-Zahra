//
//  AZUpComingEventViewModel.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 29/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import SwiftyJSON


class AZUpComingEventViewModel {
    
    var upComingEventAPI: AZUpComingEventAPI?
    weak var viewController: ViewController?
    var upComingEvents: [AZUpComingEventModel]?
    var eventId: Int?
    
    
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    func fetchEventInfo(eventType: EventType) {
        
        if eventType == .fetchEvents {
            self.upComingEventAPI = AZUpComingEventAPI(type: .fetchEvents, delegateViewModel: self)
        } else if eventType == .removeEvents {
            self.upComingEventAPI = AZUpComingEventAPI(type: .removeEvents, delegateViewModel: self)
            self.upComingEventAPI?.eventId = eventId
        }
        self.upComingEventAPI?.fetchData()
        AZProgressView.shared.showProgressView((self.viewController as! UIViewController).view)
    }
}

extension AZUpComingEventViewModel: APIDelegateViewModel {
    
    func apiSuccess(serviceType: String, model: Any?) {
        
        if serviceType == ApiConstants.ServiceType.events.rawValue {
            if let info = model as? [AZUpComingEventModel] {
                self.upComingEvents = info
                DispatchQueue.main.async {
                    
                    self.viewController?.updateView()
                }
            }
            
        } else if serviceType == ApiConstants.ServiceType.removeEvent.rawValue {
            if let info = model as? String, info == "200" {
                DispatchQueue.main.async {
                    self.upComingEvents = self.upComingEvents?.filter { $0.eventId != self.eventId }
                    self.viewController?.updateView()
                }
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
