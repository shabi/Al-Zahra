

import Foundation

public class AZCreateEventModel {
	public var eventName : String?
	public var fromDate : String?
	public var toDate : String?
	public var organisedBy : String?
	public var speaker : String?
	public var comments : String?
	public var createdBy : String?
	public var isNiyaz : Bool?
	public var pOC : String?
	public var pOCNumber : String?
	public var active : Bool?
	public var scheduler : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [AZCreateEventModel]
    {
        var models:[AZCreateEventModel] = []
        for item in array
        {
            models.append(AZCreateEventModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.

*/
	required public init?(dictionary: NSDictionary) {

		eventName = dictionary["eventName"] as? String
		fromDate = dictionary["fromDate"] as? String
		toDate = dictionary["toDate"] as? String
		organisedBy = dictionary["organisedBy"] as? String
		speaker = dictionary["speaker"] as? String
		comments = dictionary["comments"] as? String
		createdBy = dictionary["createdBy"] as? String
		isNiyaz = dictionary["isNiyaz"] as? Bool
		pOC = dictionary["pOC"] as? String
		pOCNumber = dictionary["pOCNumber"] as? String
		active = dictionary["active"] as? Bool
		scheduler = dictionary["scheduler"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.eventName, forKey: "eventName")
		dictionary.setValue(self.fromDate, forKey: "fromDate")
		dictionary.setValue(self.toDate, forKey: "toDate")
		dictionary.setValue(self.organisedBy, forKey: "organisedBy")
		dictionary.setValue(self.speaker, forKey: "speaker")
		dictionary.setValue(self.comments, forKey: "comments")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.isNiyaz, forKey: "isNiyaz")
		dictionary.setValue(self.pOC, forKey: "pOC")
		dictionary.setValue(self.pOCNumber, forKey: "pOCNumber")
		dictionary.setValue(self.active, forKey: "active")
		dictionary.setValue(self.scheduler, forKey: "scheduler")

		return dictionary
	}

}
