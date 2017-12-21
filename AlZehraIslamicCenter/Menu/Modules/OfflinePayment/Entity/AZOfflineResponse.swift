
import Foundation


public class AZOfflineResponse {
	public var userId : String?
	public var transDate : String?
	public var amount : Int?
	public var comments : String?
	public var dbCr : String?
	public var deleted : Bool?
	public var createdBy : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [AZOfflineResponse]
    {
        var models:[AZOfflineResponse] = []
        for item in array
        {
            models.append(AZOfflineResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		userId = dictionary["userId"] as? String
		transDate = dictionary["transDate"] as? String
		amount = dictionary["amount"] as? Int
		comments = dictionary["comments"] as? String
		dbCr = dictionary["dbCr"] as? String
		deleted = dictionary["deleted"] as? Bool
		createdBy = dictionary["createdBy"] as? String
	}

		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.userId, forKey: "userId")
		dictionary.setValue(self.transDate, forKey: "transDate")
		dictionary.setValue(self.amount, forKey: "amount")
		dictionary.setValue(self.comments, forKey: "comments")
		dictionary.setValue(self.dbCr, forKey: "dbCr")
		dictionary.setValue(self.deleted, forKey: "deleted")
		dictionary.setValue(self.createdBy, forKey: "createdBy")

		return dictionary
	}

}
