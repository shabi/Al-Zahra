//
//  AZEventViewController.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 30/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController

enum EventCellConstant {
    static let eventCellHeight: CGFloat = 200.0
}


class AZEventViewController: UIViewController {
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    var upComingEventViewModel:AZUpComingEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        title = "Upcoming Events"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        
        self.upComingEventViewModel = AZUpComingEventViewModel(viewController: self)
        self.upComingEventViewModel?.fetchEventInfo(eventType: .fetchEvents)
        self.setupUI()
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    func setupUI() {
        let eventCollectionViewCellNib =  UINib(nibName: AZEventCollectionViewCell.className, bundle: nil)
        self.eventCollectionView.register(eventCollectionViewCellNib, forCellWithReuseIdentifier: AZEventCollectionViewCell.className)
    }
    
}

extension AZEventViewController: ViewController {
    
    func updateView() {
        self.eventCollectionView.reloadData()
    }
}

extension AZEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.upComingEventViewModel!.upComingEvents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AZEventCollectionViewCell.className, for: indexPath) as? AZEventCollectionViewCell
        cell?.configure(eventDetails: (self.upComingEventViewModel?.upComingEvents?[indexPath.row])!)
        
        cell?.delegate = self
        return cell!
    }
}

extension AZEventViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension AZEventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.eventCollectionView.frame.size.width, height: EventCellConstant.eventCellHeight)
    }
}

extension AZEventViewController: AZEventCollectionViewCellDelegate {

    func deleteEventForId(eventId: Int?) {
        let completionHandler: ((UIAlertAction) -> Void) = { action in
            switch action.style{
            case .default:
                print("default")
                self.upComingEventViewModel?.eventId = eventId
                self.upComingEventViewModel?.fetchEventInfo(eventType: .removeEvents)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }
        
        let alert = UIAlertController(title: "Alert", message: "Want to delete this event?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: completionHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: completionHandler))
        self.present(alert, animated: true, completion: nil)
    }
}

