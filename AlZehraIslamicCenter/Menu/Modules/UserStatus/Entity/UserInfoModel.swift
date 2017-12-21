

import Foundation

public class UserInfoModel {
	public var email : String?
	public var userName : String?
	public var firstName : String?
	public var lastName : String?
	public var phoneNumber : String?
	public var payment : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let userInfoModelList = UserInfoModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of UserInfoModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserInfoModel]
    {
        var models:[UserInfoModel] = []
        for item in array
        {
            models.append(UserInfoModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let userInfoModel = UserInfoModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: UserInfoModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		email = dictionary["email"] as? String
		userName = dictionary["userName"] as? String
		firstName = dictionary["firstName"] as? String
		lastName = dictionary["lastName"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		payment = dictionary["payment"] as? String
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
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.payment, forKey: "payment")

		return dictionary
	}

}
