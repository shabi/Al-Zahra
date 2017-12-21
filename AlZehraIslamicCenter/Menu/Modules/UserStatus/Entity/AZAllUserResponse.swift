

import Foundation

public struct PaymentDetail {
    public var amount: Int?
    public var date: String?
    init(_ amount: Int, _ date: String) {
        self.amount = amount
        self.date = date
    }
}

public class AZAllUserResponse {
	public var email : String?
	public var fullName : String?
	public var phoneNumber : String?
	public var memberId : Int?
	public var enrolledAmount : Int?
	public var overdue : Int?
    public var address : String?
    public var userId : String?
    public var paymentHistory : [PaymentDetail]?

    public class func modelsFromDictionaryArray(array:NSArray) -> [AZAllUserResponse]
    {
        var models:[AZAllUserResponse] = []
        for item in array
        {
            models.append(AZAllUserResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    public class func modelFromDictionary(info: NSDictionary) -> AZAllUserResponse
    {
        let model = AZAllUserResponse(dictionary: info)
        model?.modelsFromDictionary(dictionary: info)
        return model!
    }
    
    public func modelsFromDictionary(dictionary: NSDictionary) {
        
        email = dictionary["email"] as? String
        fullName = dictionary["fullName"] as? String
        phoneNumber = dictionary["phoneNumber"] as? String
        memberId = dictionary["memberId"] as? Int
        enrolledAmount = dictionary["enrolledAmount"] as? Int
        overdue = dictionary["overdue"] as? Int
        address = dictionary["address"] as? String
        userId = dictionary["userId"] as? String
    }
    
    public class func paymentHistoryArray(paymentHistoryArray: [[String: Any]]) -> [PaymentDetail]
    {
        var models:[PaymentDetail] = []
        for item in paymentHistoryArray
        {
            let paymentDetail = PaymentDetail(item["amount"] as! Int, item["transDate"] as! String)
            models.append(paymentDetail)
        }
        return models
    }
    
	required public init?(dictionary: NSDictionary) {

		email = dictionary["email"] as? String
		fullName = dictionary["fullName"] as? String
		phoneNumber = dictionary["phoneNumber"] as? String
		memberId = dictionary["memberId"] as? Int
		enrolledAmount = dictionary["enrolledAmount"] as? Int
		overdue = dictionary["overdue"] as? Int
        address = dictionary["address"] as? String
        userId = dictionary["userId"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.fullName, forKey: "fullName")
		dictionary.setValue(self.phoneNumber, forKey: "phoneNumber")
		dictionary.setValue(self.memberId, forKey: "memberId")
		dictionary.setValue(self.enrolledAmount, forKey: "enrolledAmount")
		dictionary.setValue(self.overdue, forKey: "overdue")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.userId, forKey: "userId")

		return dictionary
	}

}
