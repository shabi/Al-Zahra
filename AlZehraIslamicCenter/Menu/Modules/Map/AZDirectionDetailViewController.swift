//
//  AZDirectionDetailViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 23/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit

class AZDirectionDetailViewController: UIViewController {
    var directionDetail = NSArray()
    var directionInfo = NSDictionary()
    var lblSrcDest = UILabel()
    
    @IBOutlet weak var directCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let directionCell =  UINib(nibName: AZDirectionCell.className, bundle: nil)
        self.directCollectionView.register(directionCell, forCellWithReuseIdentifier: AZDirectionCell.className)
        
        if let flowLayout = self.directCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        self.navigationItem.prompt = self.directionInfo .object(forKey: "end_address") as? String
        self.navigationItem.title = self.directionInfo .object(forKey: "start_address") as? String
        self.directionDetail = directionInfo.object(forKey: "steps") as! NSArray
    }
//
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        if section == 0 {
//            return 1
//        }
//        return self.directionDetail.count
//    }
//
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if (section == 0) {
//            return "Driving directions Summary"
//        }else{
//            return "Driving directions Detail"
//        }
//    }
    
}

extension AZDirectionDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.directionDetail.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AZDirectionCell.className, for: indexPath) as? AZDirectionCell
        
        if indexPath.section == 0 {
            
            
            cell?.directionDescription.text = String(format:"total Distace = %@ \ntotal Duration = %@", directionInfo.value(forKey: "distance") as! String, directionInfo.value(forKey: "duration") as! String)
            
            cell?.directionDetail.text = String(format:"Driving directions \nfrom \n%@ \nto \n%@",directionInfo.value(forKey: "start_address")as! String,directionInfo.value(forKey: "end_address")as! String) as String
        }else{
            let idx:Int = indexPath.row
            let dictTable:NSDictionary = self.directionDetail[idx] as! NSDictionary
            cell?.directionDetail.text =  dictTable["instructions"] as? String
            let distance = dictTable["distance"] as! NSString
            let duration = dictTable["duration"] as! NSString
            let detail = "distance : \(distance) duration : \(duration)"
            cell?.directionDescription.text = detail
        }
        return cell!
    }
}

extension AZDirectionDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
