//
//  AZDirectionManager.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 23/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

typealias DirectionsCompletionHandler = ((_ route:MKPolyline?, _ directionInformation:NSDictionary?, _ boundingRegion:MKMapRect?, _ error:String?)->())?

class AZDirectionManager: NSObject {
    private var directionsCompletionHandler:DirectionsCompletionHandler
    private let errorNoRoutesAvailable = "No routes available"// add more error handling
    
    private let errorDictionary = ["NOT_FOUND" : "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded",
                                   "ZERO_RESULTS":"No route could be found between the origin and destination",
                                   "MAX_WAYPOINTS_EXCEEDED":"Too many waypointss were provided in the request The maximum allowed waypoints is 8, plus the origin, and destination",
                                   "INVALID_REQUEST":"The provided request was invalid. Common causes of this status include an invalid parameter or parameter value",
                                   "OVER_QUERY_LIMIT":"Service has received too many requests from your application within the allowed time period",
                                   "REQUEST_DENIED":"Service denied use of the directions service by your application",
                                   "UNKNOWN_ERROR":"Directions request could not be processed due to a server error. Please try again"]
    
    override init(){
        super.init()
    }
    
    func directions(from:CLLocationCoordinate2D,to:NSString,directionCompletionHandler:DirectionsCompletionHandler) {
        self.directionsCompletionHandler = directionCompletionHandler
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else {
                let placemark = placemarksObject!.last!
                
                let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
                
                let source = MKMapItem(placemark: placemarkSource)
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
            }
        })
    }
    
    func directionsFromCurrentLocation(to:NSString,directionCompletionHandler:DirectionsCompletionHandler) {
        self.directionsCompletionHandler = directionCompletionHandler
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else{
                let placemark = placemarksObject!.last!
                let source = MKMapItem.forCurrentLocation()
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
            }
        })
    }
    
    func directionsFromCurrentLocation(to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler) {
        let source = MKMapItem.forCurrentLocation()
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        let destination = MKMapItem(placemark: placemarkDestination)
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
    }
    
    func directions(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler) {
        let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
        let source = MKMapItem(placemark: placemarkSource)
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        let destination = MKMapItem(placemark: placemarkDestination)
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
    }
    
    private func directionsFor(source:MKMapItem, destination:MKMapItem, directionCompletionHandler:DirectionsCompletionHandler) {
        self.directionsCompletionHandler = directionCompletionHandler
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = MKDirectionsTransportType.any
        directionRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            (response:MKDirectionsResponse?, error:NSError?) -> Void in
            if let error = error {
                self.directionsCompletionHandler!(nil,nil, nil, error.localizedDescription)
            }
            else if response!.routes.isEmpty {
                self.directionsCompletionHandler!(nil,nil, nil, self.errorNoRoutesAvailable)
            }
            else{
                let route: MKRoute = response!.routes[0]
                let steps = route.steps as NSArray
                let end_address = route.name
                let distance = route.distance.description
                let duration = route.expectedTravelTime.description
                
                let source = response!.source.placemark.coordinate
                let destination = response!.destination.placemark.coordinate
                
                let start_location = ["lat":source.latitude,"lng":source.longitude]
                let end_location = ["lat":destination.latitude,"lng":destination.longitude]
                
                let stepsFinalArray = NSMutableArray()
                
                steps.enumerateObjects({ (obj, idx, stop) -> Void in
                    let step:MKRouteStep = obj as! MKRouteStep
                    let distance = step.distance.description
                    let instructions = step.instructions
                    let stepsDictionary = NSMutableDictionary()
                    
                    stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
                    stepsDictionary.setObject("", forKey: "duration" as NSCopying)
                    stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
                    
                    stepsFinalArray.add(stepsDictionary)
                })
                
                let stepsDict = NSMutableDictionary()
                stepsDict.setObject(distance, forKey: "distance" as NSCopying as NSCopying)
                stepsDict.setObject(duration, forKey: "duration" as NSCopying)
                stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
                stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
                stepsDict.setObject("", forKey: "start_address" as NSCopying)
                stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
                stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
                
                self.directionsCompletionHandler!(route.polyline,stepsDict, route.polyline.boundingMapRect, nil)
            }
            } as! MKDirectionsHandler)
    }
    
    /**
     Get directions using Google API by passing source and destination as string.
     - parameter from: Starting point of journey
     - parameter to: Ending point of journey
     - returns: directionCompletionHandler: Completion handler contains polyline,dictionary,maprect and error
     */
    func directionsUsingGoogleWithString(from:NSString, to:NSString,directionCompletionHandler:DirectionsCompletionHandler) {
        getDirectionsUsingGoogle(origin: from, destination: to, directionCompletionHandler: directionCompletionHandler)
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        let originLatLng = "\(from.latitude),\(from.longitude)"
        let destinationLatLng = "\(to.latitude),\(to.longitude)"
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: destinationLatLng as NSString, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        let originLatLng = "\(from.latitude),\(from.longitude)"
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: to, directionCompletionHandler: directionCompletionHandler)
    }
    
    private func getDirectionsUsingGoogle(origin:NSString, destination:NSString,directionCompletionHandler:DirectionsCompletionHandler) {
        self.directionsCompletionHandler = directionCompletionHandler
        let path = "http://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)"
        performOperationForURL(urlString: path as NSString)
    }
    
    private func performOperationForURL(urlString:NSString){
        let urlEncoded = urlString.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string:urlEncoded)
        let request = NSMutableURLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
            }
            else{
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                print(jsonResult.object(forKey: "status") ?? "")
                let routes = jsonResult.object(forKey: "routes") as! NSArray
                let status = jsonResult.object(forKey: "status") as! NSString
                if routes.count > 0{
                    let route = routes.lastObject as! NSDictionary //first object?
                    if status.isEqual(to: "OK") && route.allKeys.count > 0  {
                        let legs = route.object(forKey: "legs") as! NSArray
                        let steps = legs.firstObject as! NSDictionary
                        let directionInformation = self.parser(data: steps) as NSDictionary
                        let overviewPolyline = route.object(forKey: "overview_polyline") as! NSDictionary
                        let points = overviewPolyline.object(forKey: "points") as! NSString
                        let locations = self.decodePolyLine(encodedStr: points) as Array
                        var coordinates = locations.map({ (location: CLLocation) ->
                            CLLocationCoordinate2D in
                            return location.coordinate
                        })
                        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
                        self.directionsCompletionHandler!(polyline,directionInformation, polyline.boundingMapRect, nil)
                    }
                }else{
                    var errorMsg = self.errorDictionary[status as String]
                    if errorMsg == nil {
                        errorMsg = self.errorNoRoutesAvailable
                    }
                    self.directionsCompletionHandler!(nil,nil, nil, errorMsg)
                }
            }
            
        }
        task.resume()
    }
    
    private func decodePolyLine(encodedStr:NSString)->Array<CLLocation>{
        var array = Array<CLLocation>()
        let len = encodedStr.length
        let range = NSMakeRange(0, len)
        var strpolyline = encodedStr
        var index = 0
        var lat = 0 as Int32
        var lng = 0 as Int32
        
        strpolyline = encodedStr.replacingOccurrences(of: "\\\\", with: "\\", options: String.CompareOptions.literal, range: range) as NSString
        while(index<len){
            var b = 0
            var shift = 0
            var result = 0
            repeat {
                let numUnichar = strpolyline.character(at: index)
                index = index + 1
                
                let num =  NSNumber(value: numUnichar)
                let numInt = num.intValue
                b = numInt - 63
                result |= (b & 0x1f) << shift
                shift += 5
            } while(b >= 0x20)
            
            var dlat = 0
            
            if((result & 1) == 1){
                dlat = ~(result >> 1)
            }
            else{
                dlat = (result >> 1)
            }
            
            lat = lat + dlat
            
            shift = 0
            result = 0
            
            repeat {
                
                let numUnichar = strpolyline.character(at: index)
                index = index + 1
                let num =  NSNumber(value: numUnichar)
                let numInt = num.intValue
                b = numInt - 63
                result |= (b & 0x1f) << shift
                shift += 5
            } while(b >= 0x20)
            
            var dlng = 0
            
            if((result & 1) == 1){
                dlng = ~(result >> 1)
            }
            else{
                dlng = (result >> 1)
            }
            
            lng = lng + dlat
            
            let latitude = NSNumber(value:lat).doubleValue * 1e-5
            let longitude = NSNumber(value:lng).doubleValue * 1e-5
            let location = CLLocation(latitude: latitude, longitude: longitude)
            array.append(location)
        }
        return array
    }
    
    private func parser(data:NSDictionary)->NSDictionary{
        let distance = (data.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
        let duration = (data.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
        let end_address = data.object(forKey: "end_address") as! NSString
        let end_location = data.object(forKey: "end_location") as! NSDictionary
        let start_address = data.object(forKey: "start_address") as! NSString
        let start_location = data.object(forKey: "start_location") as! NSDictionary
        let stepsArray = data.object(forKey: "steps") as! NSArray
        let stepsDict = NSMutableDictionary()
        let stepsFinalArray = NSMutableArray()
        
        stepsArray.enumerateObjects ({ (obj, idx, stop) -> Void in
            let stepDict = obj as! NSDictionary
            let distance = (stepDict.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
            let duration = (stepDict.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
            let html_instructions = stepDict.object(forKey: "html_instructions") as! NSString
            let end_location = stepDict.object(forKey: "end_location") as! NSDictionary
            let instructions = self.removeHTMLTags(source: (stepDict.object(forKey: "html_instructions") as! NSString))
            let start_location = stepDict.object(forKey: "start_location") as! NSDictionary
            let stepsDictionary = NSMutableDictionary()
            stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
            stepsDictionary.setObject(duration, forKey: "duration" as NSCopying)
            stepsDictionary.setObject(html_instructions, forKey: "html_instructions" as NSCopying)
            stepsDictionary.setObject(end_location, forKey: "end_location" as NSCopying)
            stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
            stepsDictionary.setObject(start_location, forKey: "start_location" as NSCopying)
            stepsFinalArray.add(stepsDictionary)
        })
        stepsDict.setObject(distance, forKey: "distance" as NSCopying)
        stepsDict.setObject(duration, forKey: "duration" as NSCopying)
        stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
        stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
        stepsDict.setObject(start_address, forKey: "start_address" as NSCopying)
        stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
        stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
        return stepsDict
    }
    
    private func removeHTMLTags(source:NSString)->NSString{
        var range = NSMakeRange(0, 0)
        let HTMLTags = "<[^>]*>"
        
        var sourceString = source
        while( sourceString.range(of: HTMLTags, options: String.CompareOptions.regularExpression).location != NSNotFound){
            range = sourceString.range(of: HTMLTags, options: String.CompareOptions.regularExpression)
            sourceString = sourceString.replacingCharacters(in: range, with: "") as NSString
        }
        return sourceString;
    }
}



