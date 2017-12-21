
import Foundation
 

public class AZCreateAccountResponse {
	public var url : String?
	public var id : String?
	public var userName : String?
	public var fullName : String?
	public var email : String?
	public var emailConfirmed : String?
	public var level : Int?
	public var joinDate : String?
	public var roles : Array<String>?
	public var claims : Array<String>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let createAccountResponse_list = AZCreateAccountResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZCreateAccountResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZCreateAccountResponse]
    {
        var models:[AZCreateAccountResponse] = []
        for item in array
        {
            models.append(AZCreateAccountResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let createAccountResponse = AZCreateAccountResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZCreateAccountResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

		url = dictionary["url"] as? String
		id = dictionary["id"] as? String
		userName = dictionary["userName"] as? String
		fullName = dictionary["fullName"] as? String
		email = dictionary["email"] as? String
		emailConfirmed = dictionary["emailConfirmed"] as? String
		level = dictionary["level"] as? Int
		joinDate = dictionary["joinDate"] as? String
		if (dictionary["roles"] != nil) { roles = dictionary["roles"] as! NSArray as? Array<String> }
		if (dictionary["claims"] != nil) { claims = dictionary["claims"] as! NSArray as? Array<String> }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.url, forKey: "url")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.userName, forKey: "userName")
		dictionary.setValue(self.fullName, forKey: "fullName")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.emailConfirmed, forKey: "emailConfirmed")
		dictionary.setValue(self.level, forKey: "level")
		dictionary.setValue(self.joinDate, forKey: "joinDate")

		return dictionary
	}

}
