

import Foundation

public class AZUpComingEventModel {
	public var eventName : String?
	public var organisedBy : String?
	public var poc : String?
	public var pocNumber : Int?
	public var isNiyaz : String?
	public var comments : String?
	public var speakerName : String?
	public var fromDate : String?
	public var toDate : String?
	public var fromTime : String?
	public var toTime : String?
    public var eventId : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let upComingEventModel_list = AZUpComingEventModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZUpComingEventModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZUpComingEventModel]
    {
        var models:[AZUpComingEventModel] = []
        for item in array
        {
            models.append(AZUpComingEventModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let upComingEventModel = AZUpComingEventModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZUpComingEventModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		eventName = dictionary["eventName"] as? String
		organisedBy = dictionary["organisedBy"] as? String
		poc = dictionary["poc"] as? String
		pocNumber = dictionary["pocNumber"] as? Int
		isNiyaz = dictionary["isNiyaz"] as? String
		comments = dictionary["comments"] as? String
		speakerName = dictionary["speakerName"] as? String
		fromDate = dictionary["fromDate"] as? String
		toDate = dictionary["toDate"] as? String
		fromTime = dictionary["fromTime"] as? String
		toTime = dictionary["toTime"] as? String
        eventId = dictionary["id"] as? Int
        
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.eventName, forKey: "eventName")
		dictionary.setValue(self.organisedBy, forKey: "organisedBy")
		dictionary.setValue(self.poc, forKey: "poc")
		dictionary.setValue(self.pocNumber, forKey: "pocNumber")
		dictionary.setValue(self.isNiyaz, forKey: "isNiyaz")
		dictionary.setValue(self.comments, forKey: "comments")
		dictionary.setValue(self.speakerName, forKey: "speakerName")
		dictionary.setValue(self.fromDate, forKey: "fromDate")
		dictionary.setValue(self.toDate, forKey: "toDate")
		dictionary.setValue(self.fromTime, forKey: "fromTime")
		dictionary.setValue(self.toTime, forKey: "toTime")
        dictionary.setValue(self.eventId, forKey: "id")
        

		return dictionary
	}

}
