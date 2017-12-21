
import Foundation
 
public class AZCreateAccountRequest {
	public var email : String?
	public var userName : String?
	public var firstName : String?
	public var lastName : String?
	public var password : String?
	public var confirmPassword : String?
	public var phoneNumber : String?
	public var roleName : String?
    
    public var address : String?
    public var city : String?
    public var stateCode : String?
    public var zipCode : String?
    public var amount : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let createAccountRequest_list = AZCreateAccountRequest.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZCreateAccountRequest Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZCreateAccountRequest]
    {
        var models:[AZCreateAccountRequest] = []
        for item in array
        {
            models.append(AZCreateAccountRequest(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		email = dictionary["email"] as? String
		userName = dictionary["userName"] as? String
		firstName = dictionary["firstName"] as? String
		lastName = dictionary["lastName"] as? String
		password = dictionary["password"] as? String
		confirmPassword = dictionary["confirmPassword"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		roleName = dictionary["roleName"] as? String
        
        address = dictionary["address"] as? String
        city = dictionary["city"] as? String
        stateCode = dictionary["stateCode"] as? String
        zipCode = dictionary["zipCode"] as? String
        amount = dictionary["amount"] as? String

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.userName, forKey: "userName")
		dictionary.setValue(self.firstName, forKey: "firstName")
		dictionary.setValue(self.lastName, forKey: "lastName")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.confirmPassword, forKey: "confirmPassword")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.roleName, forKey: "roleName")
        
        
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.stateCode, forKey: "stateCode")
        dictionary.setValue(self.zipCode, forKey: "zipCode")
        dictionary.setValue(self.amount, forKey: "amount")
		return dictionary
	}

}
