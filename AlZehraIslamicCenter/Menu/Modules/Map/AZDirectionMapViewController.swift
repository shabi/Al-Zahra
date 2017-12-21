//
//  AZDirectionMapViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 23/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import KYDrawerController

class AZDirectionMapViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, LocateOnTheMap {
    var searchResultController: AZSearchDirectionResultViewController!
    var resultsArray = [String]()
    var fromClicked = Bool()
    var mapManager = AZDirectionManager()
    var tableData = NSDictionary()
    var polyline = MKPolyline()
    
    @IBOutlet weak var drawMap: MKMapView!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultController = AZSearchDirectionResultViewController()
        searchResultController.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        drawMap.delegate = self

    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField .resignFirstResponder()
        if textField.tag == 0 {
            fromClicked = true
        }else
        {
            fromClicked = false
        }
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async {
            if self.fromClicked{
                self.txtFrom.text = title
                self.navigationItem.prompt = String(format: "From :%f,%f",lat,lon)
            }else
            {
                self.txtTo.text = title
                self.navigationItem.title = String(format: "TO :%f,%f",lat,lon)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        let placesClient = GMSPlacesClient()
       
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: Error?) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(array: self.resultsArray)
        }
    }
    
    
    
    func removeAllPlacemarkFromMap(shouldRemoveUserLocation:Bool) {
        if let mapView = self.drawMap {
            for annotation in mapView.annotations{
                if shouldRemoveUserLocation {
                    if annotation as? MKUserLocation !=  mapView.userLocation {
                        mapView.removeAnnotation(annotation as MKAnnotation)
                    }
                }
                let overlays = mapView.overlays
                mapView.removeOverlays(overlays)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickToGetDirection(sender: AnyObject) {
        if self.tableData.count > 0 {
           let viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .directionDetailViewController) as? AZDirectionDetailViewController
            viewController?.directionInfo = self.tableData
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    @IBAction func ClickToGo(sender: AnyObject) {
        if isValidPincode() {
            mapManager.directionsUsingGoogleWithString(from: txtFrom.text! as NSString as NSString, to: txtTo.text! as NSString, directionCompletionHandler: { (route, directionInformation, boundingRegion, error) -> () in
                
                if(error != nil){
                    print(error ?? "")
                }
                else{
                    let pointOfOrigin = MKPointAnnotation()
                    pointOfOrigin.coordinate = route!.coordinate
                    pointOfOrigin.title = directionInformation?.object(forKey: "start_address") as! NSString as String
                    pointOfOrigin.subtitle = directionInformation?.object(forKey: "duration") as! NSString as String
                    
                    let pointOfDestination = MKPointAnnotation()
                    pointOfDestination.coordinate = route!.coordinate
                    pointOfDestination.title = directionInformation?.object(forKey: "end_address") as! NSString as String
                    pointOfDestination.subtitle = directionInformation?.object(forKey: "distance") as! NSString as String
                    
                    let start_location = directionInformation?.object(forKey: "start_location") as! NSDictionary
                    let originLat = (start_location.object(forKey: "lat") as AnyObject).doubleValue
                    let originLng = (start_location.object(forKey: "lng") as AnyObject).doubleValue
                    
                    let end_location = directionInformation?.object(forKey: "end_location") as! NSDictionary
                    let destLat = (end_location.object(forKey: "lat") as AnyObject).doubleValue
                    let destLng = (end_location.object(forKey: "lng") as AnyObject).doubleValue
                    
                    let coordOrigin = CLLocationCoordinate2D(latitude: originLat!, longitude: originLng!)
                    let coordDesitination = CLLocationCoordinate2D(latitude: destLat!, longitude: destLng!)
                    
                    pointOfOrigin.coordinate = coordOrigin
                    pointOfDestination.coordinate = coordDesitination
                    if let web = self.drawMap {
                        DispatchQueue.main.async() {
                            self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
                            web.add(route!)
                            web.addAnnotation(pointOfOrigin)
                            web.addAnnotation(pointOfDestination)
                            web.setVisibleMapRect(boundingRegion!, animated: true)
                            print(directionInformation ?? "")
                            self.tableData = directionInformation!
                        }
                    }
                }
            })
            
        }
    }
    
    func isValidPincode() -> Bool {
        if txtFrom.text?.count == 0
        {
            self .showAlert(value: "Please enter your source address")
            return false
        }else if txtTo.text?.count == 0
        {
            self .showAlert(value: "Please enter your destination address")
            return false
        }
        return true
    }
    func showAlert(value:NSString)
    {
        let alert = UIAlertController(title: "Please enter your source address", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
extension AZDirectionMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            polylineRenderer.strokeColor = UIColor.init(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
}


