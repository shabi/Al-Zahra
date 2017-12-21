

import Foundation
 
public class AZAuthTokenResponse {
	public var access_token : String?
	public var token_type : String?
	public var expires_in : Int?
	public var client_id : String?
	public var userName : String?
	public var role : String?
	public var issued : String?
	public var expires : String?
    public var userId : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let AZAuthTokenResponse_list = AZAuthTokenResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZAuthTokenResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZAuthTokenResponse]
    {
        var models:[AZAuthTokenResponse] = []
        for item in array
        {
            models.append(AZAuthTokenResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let AZAuthTokenResponse = AZAuthTokenResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZAuthTokenResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

		access_token = dictionary["access_token"] as? String
		token_type = dictionary["token_type"] as? String
		expires_in = dictionary["expires_in"] as? Int
		client_id = dictionary["as:client_id"] as? String
		userName = dictionary["userName"] as? String
		role = dictionary["role"] as? String
		issued = dictionary[".issued"] as? String
		expires = dictionary[".expires"] as? String
        userId = dictionary["userId"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.access_token, forKey: "access_token")
		dictionary.setValue(self.token_type, forKey: "token_type")
		dictionary.setValue(self.expires_in, forKey: "expires_in")
		dictionary.setValue(self.client_id, forKey: "as:client_id")
		dictionary.setValue(self.userName, forKey: "userName")
		dictionary.setValue(self.role, forKey: "role")
		dictionary.setValue(self.issued, forKey: ".issued")
		dictionary.setValue(self.expires, forKey: ".expires")
        dictionary.setValue(self.userId, forKey: "userId")
        
		return dictionary
	}
    
    func saveInKeyChain() {
        Keychain.saveValueInKeychain(value: self.access_token!, key: Constants.KeyChain.accessToken)
        Keychain.saveValueInKeychain(value: self.token_type!, key: Constants.KeyChain.tokenType)
        Keychain.saveValueInKeychain(value: String(describing: self.expires_in), key: Constants.KeyChain.expiresIn)
        Keychain.saveValueInKeychain(value: self.userName!, key: Constants.KeyChain.userName)
        Keychain.saveValueInKeychain(value: self.role!, key: Constants.KeyChain.role)
        Keychain.saveValueInKeychain(value: self.expires!, key: Constants.KeyChain.expires)
        Keychain.saveValueInKeychain(value: self.expires!, key: Constants.KeyChain.expires)
        Keychain.saveValueInKeychain(value: self.userId!, key: Constants.KeyChain.userId)
        if let password = AppDataManager.shared.userPassword {
            Keychain.saveValueInKeychain(value: password, key: Constants.KeyChain.password)
        }
        
    }
    
    class func retrieveFromKeyChain() -> AZAuthTokenResponse? {
        if let aToken = Keychain.loadValueFromKeychain(key: Constants.KeyChain.accessToken),
            let tokenType = Keychain.loadValueFromKeychain(key: Constants.KeyChain.tokenType),
            let expiresIn = Keychain.loadValueFromKeychain(key: Constants.KeyChain.expiresIn),
            let _ = Int(expiresIn),
            let userName = Keychain.loadValueFromKeychain(key: Constants.KeyChain.userName),
            let role = Keychain.loadValueFromKeychain(key: Constants.KeyChain.role),
            let expires = Keychain.loadValueFromKeychain(key: Constants.KeyChain.expires),
            let userId = Keychain.loadValueFromKeychain(key: Constants.KeyChain.userId) {
            
            let dic = [Constants.KeyChain.accessToken: aToken, Constants.KeyChain.tokenType: tokenType,
                       Constants.KeyChain.expiresIn: expiresIn, Constants.KeyChain.userName: userName,
                       Constants.KeyChain.role: role, Constants.KeyChain.expires: expires,
                       Constants.KeyChain.userId: userId]
            
            return AZAuthTokenResponse(dictionary: dic as NSDictionary)
            
        }
        return nil
    }
    
    //MARK: Reset Keychain
    class func resetKeychainItems() {
        
        //Samsung account related
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.accessToken)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.tokenType)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.expiresIn)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.userName)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.role)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.expires)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.userId)
        Keychain.removeValueFromKeychain(key: Constants.KeyChain.password)
    }

}
