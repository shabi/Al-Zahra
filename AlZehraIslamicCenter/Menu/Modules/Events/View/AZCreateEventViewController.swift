//
//  AZCreateEventViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 16/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import DateTimePicker

enum SchedulerType: Int {
    case daily = 1
    case weekly = 7
    case monthly = 2
}

enum SelectedDate: Int {
    case fromDate = 1
    case toDate = 2
}
class AZCreateEventViewController: UIViewController, PRGValidationFieldDelegate {
    
    @IBOutlet weak var eventName: PRGValidationField!
    @IBOutlet weak var speaker: PRGValidationField!
    @IBOutlet weak var poc: PRGValidationField!
    @IBOutlet weak var pocContact: PRGValidationField!
    @IBOutlet weak var creator: PRGValidationField!
    @IBOutlet weak var organisedBy: PRGValidationField!
    
    @IBOutlet weak var schedularDaily: UIButton!
    @IBOutlet weak var schedularWeekly: UIButton!
    @IBOutlet weak var schedularMonthly: UIButton!
    @IBOutlet weak var isActive: UIButton!
    @IBOutlet weak var isNiyaz: UIButton!
    @IBOutlet weak var comment: PRGValidationField!
    @IBOutlet weak var createEventButton: UIButton!
    var dateType: SelectedDate = .fromDate
    
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var picker: DateTimePicker?
    
    var createEventViewModel: AZCreateEventViewModel?
    
    
    var isNiyazSelected: Bool = false {
        
        didSet {
            if self.isNiyazSelected == true {
                self.isNiyaz.setImage(UIImage(named: "SelectedCheckBox"), for: .normal)
            } else {
                self.isNiyaz.setImage(UIImage(named: "UnSelectedBox"), for: .normal)
            }
        }
    }
    var isActiveSelected: Bool = false {
        didSet {
            if self.isActiveSelected == true {
                self.isActive.setImage(UIImage(named: "SelectedCheckBox"), for: .normal)
            } else {
                self.isActive.setImage(UIImage(named: "UnSelectedBox"), for: .normal)
            }
        }
    }
    
    var schedularSelectedType: SchedulerType = .daily {
        
        didSet {
            switch schedularSelectedType {
            case .daily:
                self.defaultSchedularSetting()
                self.schedularDaily.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            case .weekly:
                self.defaultSchedularSetting()
                self.schedularWeekly.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            case .monthly:
                self.defaultSchedularSetting()
                self.schedularMonthly.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            }
        }
    }
    
    func defaultSchedularSetting()  {
        self.schedularDaily.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
        self.schedularWeekly.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
        self.schedularMonthly.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Create New Event"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.defaultSchedularSetting()
        
        self.eventName.delegate = self
        self.speaker.delegate = self
        self.poc.delegate = self
        self.pocContact.delegate = self
        self.creator.delegate = self
        self.organisedBy.delegate = self
        self.comment.delegate = self
        
        self.createEventViewModel = AZCreateEventViewModel(viewController: self)
        
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PRGValidationField(_field: PRGValidationField, didValidateWithResult result: Bool, andErrorMessage errorMessage: String?) {

        self.createEventButton.isEnabled = eventName.isValid ?? false && speaker.isValid ?? false && poc.isValid ?? false && pocContact.isValid ?? false && creator.isValid ?? false && organisedBy.isValid ?? false

    }
    
    
    @IBAction func selectEventDateAction(_ sender: UIButton) {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 100)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 100)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.is12HourFormat = true
        
        picker.darkColor = UIColor.gray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        picker.includeMonth = false
        picker.completionHandler = { date in
//            let formatter = DateFormatter()
//            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
//            self.title = formatter.string(from: date)
            let dateString = date.getStringWithFormat(format: .monthDayYearTimeFormat)
            if sender.tag == 0 {
                self.fromDateButton.setTitle(dateString, for: .normal)
            } else if sender.tag == 1 {
                self.toDateButton.setTitle(dateString, for: .normal)
            }
        }
        self.picker = picker
    }
    
    @IBAction func schedularTapped(_ sender: UIButton) {
        self.resignFirstResponder()
        self.schedularSelectedType = SchedulerType(rawValue: (sender as UIButton).tag)!
    }
    @IBAction func isActiveTapped(_ sender: UIButton) {
        self.resignFirstResponder()
        if self.isActiveSelected {
            self.isActiveSelected = false
        } else {
            self.isActiveSelected = true
        }
    }
    @IBAction func isNiyazTapped(_ sender: UIButton) {
        self.resignFirstResponder()
        if self.isNiyazSelected {
            self.isNiyazSelected = false
        } else {
            self.isNiyazSelected = true
        }
    }
    
    func resetForm() {
        print("call create event service")
        self.resignFirstResponder()
        self.eventName.valueField.text = ""
        self.organisedBy.valueField.text = ""
        self.speaker.valueField.text = ""
        self.creator.valueField.text = ""
        self.poc.valueField.text = ""
        self.pocContact.valueField.text = ""
        self.comment.valueField.text = ""
        self.isNiyazSelected = false
        self.isActiveSelected = false
        self.schedularSelectedType = .daily
    }
    
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
        print("call create event service")
        self.resignFirstResponder()
                
        let eventDic = ["eventName": self.eventName.text as AnyObject, "fromDate": self.fromDateButton.titleLabel?.text as AnyObject,
                        "toDate": self.toDateButton.titleLabel?.text as AnyObject, "organisedBy": self.organisedBy.text as AnyObject,
                        "speaker": self.speaker.text as AnyObject, "comments": self.comment.text as AnyObject,
                        "createdBy": self.creator.text as AnyObject, "isNiyaz": self.isNiyazSelected as AnyObject,
                        "pOC": self.poc.text as AnyObject, "pOCNumber": self.pocContact.text as AnyObject,
                        "active": self.isActiveSelected as AnyObject, "scheduler": self.schedularSelectedType.rawValue as AnyObject]
        
        
        
        self.createEventViewModel?.createEventModel = AZCreateEventModel(dictionary: eventDic as NSDictionary)
        self.createEventViewModel?.fetchEventInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            _ = touch.location(in: self.view)
        }
    }

    
}

extension AZCreateEventViewController: ViewController {
    
    func updateView() {
        //Successfully created event
        // reset field.
        AZUtility.showAlert(title: "Create Event", message: "Successfully event created.", actionTitles: "OK", actions: nil)
        self.resetForm()
        self.createEventButton.isEnabled = false
    }
}
