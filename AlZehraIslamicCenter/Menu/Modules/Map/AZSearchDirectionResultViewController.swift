//
//  AZSearchDirectionResultViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 23/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit

protocol LocateOnTheMap{
    func locateWithLongitude(lon:Double, andLatitude lat:Double, andTitle title: String)
}

class AZSearchDirectionResultViewController: UIViewController {
    
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        let directionSearchCell =  UINib(nibName: AZDirectionSearchCell.className, bundle: nil)
        self.searchResultCollectionView.register(directionSearchCell, forCellWithReuseIdentifier: AZDirectionSearchCell.className)        
    }

    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.searchResultCollectionView.reloadData()
    }
    
}

extension AZSearchDirectionResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AZDirectionSearchCell.className, for: indexPath) as? AZDirectionSearchCell
        
        cell?.searchLabel.text = self.searchResults[indexPath.row]
        return cell!
    }
}

extension AZSearchDirectionResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1
        self.dismiss(animated: true, completion: nil)
        // 2
        let correctedAddress = self.searchResults[indexPath.row].addingPercentEncoding( withAllowedCharacters: .symbols)

        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(String(describing: correctedAddress))&sensor=false")
        let request = NSMutableURLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // 3
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    print(dic)

//                    let lat = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
//                    let lon = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as! Double
                    // 4
//                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
                }
                
            }catch {
                print("Error")
            }
        }
        task.resume()
    }
}

extension AZSearchDirectionResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.searchResultCollectionView.frame.size.width, height: 40)
    }
    
}
