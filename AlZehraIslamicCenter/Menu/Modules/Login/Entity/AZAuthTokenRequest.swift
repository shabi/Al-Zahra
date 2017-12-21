

import Foundation

public class AZAuthTokenRequest {
	public var username : String?
	public var password : String?
	public var grant_type : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let AZAuthTokenRequest_list = AZAuthTokenRequest.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZAuthTokenRequest Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZAuthTokenRequest]
    {
        var models:[AZAuthTokenRequest] = []
        for item in array
        {
            models.append(AZAuthTokenRequest(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let AZAuthTokenRequest = AZAuthTokenRequest(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZAuthTokenRequest Instance.
*/
	required public init?(dictionary: NSDictionary) {

		username = dictionary["username"] as? String
		password = dictionary["password"] as? String
		grant_type = dictionary["grant_type"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.username, forKey: "username")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.grant_type, forKey: "grant_type")

		return dictionary
	}

}
