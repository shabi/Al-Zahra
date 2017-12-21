//
//  AZContactUsViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 28/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

enum Location {
    case startLocation
    case endLocation
}

class AZContactUsViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var startLocation = CLLocation()
    var endLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
//
//        let camera = GMSCameraPosition.camera(withLatitude: 33.487007, longitude: -117.143784, zoom: 15.0)
//
//        self.googleMapView.camera = camera
//        self.googleMapView.delegate = self
//        self.googleMapView.isMyLocationEnabled = true
//        self.googleMapView.settings.myLocationButton = true
//        self.googleMapView.settings.compassButton = true
//        self.googleMapView.settings.zoomGestures = true

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Contact"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func createMarker(title: String, icon: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = title
        marker.icon = icon
        marker.map = self.googleMapView
    }
    
    @IBAction func socialSiteTapped(sender: UIButton) {
        if sender.tag == 0 {
            self.openContactDetail(url: "https://www.youtube.com/channel/UCWnnYaxN4BFvZTlgKrQDoXA")
        } else if sender.tag == 1 {
            self.openContactDetail(url: "https://www.facebook.com/groups/140000089352849/?fref=nf")
        } else if sender.tag == 2 {
            self.openContactDetail(url: "https://www.instagram.com/al_zahra_islamic_center_nc/")
        }
    }
    
    
    func openContactDetail(url: String) {
        let wkViewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .wkViewController) as? AZWKViewController
        wkViewController?.urlStr = url
        self.navigationController?.pushViewController(wkViewController!, animated: true)
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension AZContactUsViewController: ViewController {
    
    func updateView() {}
}

extension AZContactUsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let endLocation = CLLocation(latitude: 35.227085, longitude: -80.843124)
        
        createMarker(title: "Masjid", icon: #imageLiteral(resourceName: "Annotation"), latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
        createMarker(title: "Your Location", icon: #imageLiteral(resourceName: "Annotation"), latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        self.drawPath(startLocation: location!, endLocation: endLocation)
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapView.isMyLocationEnabled = true
        if gesture {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.googleMapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Cordinates: \(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.googleMapView.isMyLocationEnabled = true
        self.googleMapView.selectedMarker = nil
        return false
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let origin = "\(startLocation.coordinate.latitude), \(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude), \(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood4&key=AIzaSyCNYURSJVQCl6ahemxkjoDoDnNHc9QtUNk"

//        let url = "https://maps.googleapis.com/maps/api//direction/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyC3rRfe_RQGozrjBqrj_h_D98UKeLFLnQw"
        Alamofire.request(url).responseJSON { response in
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.blue
                    polyline.map = self.googleMapView
                }
            } catch { print(error.localizedDescription) }
            
//            let json = JSON(data: response.data!)
//            let routes = json["routes"].arrayValue
//            
//            for route in routes {
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points!)
//                let polyline = GMSPolyline.init(path: path)
//                polyline.strokeWidth = 4
//                polyline.strokeColor = UIColor.blue
//                polyline.map = self.googleMapView
//            }
        }
    }
    
    @IBAction func showDirection(_ sender: UIButton) {
////        33.487007, -117.143784
//        self.drawPath(startLocation: CLLocation(latitude: 33.487007, longitude: -117.143784), endLocation: CLLocation(latitude: 35.227085, longitude: -80.843124))
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(Float(28.38)),\(Float(77.12))&directionsmode=driving")! as URL)
        } else
        {
            NSLog("Can't use com.google.maps://");
        }
    }
}
