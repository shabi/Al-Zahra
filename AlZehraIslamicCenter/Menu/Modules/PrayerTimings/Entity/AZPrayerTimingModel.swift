
import Foundation
 

public class AZPrayerTimingModel {
	public var imsaak : String?
	public var fajr : String?
	public var sunrise : String?
	public var dhuhr : String?
	public var asr : String?
	public var sunset : String?
	public var maghrib : String?
	public var isha : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let AZPrayerTimingModel_list = AZPrayerTimingModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZPrayerTimingModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZPrayerTimingModel]
    {
        var models:[AZPrayerTimingModel] = []
        for item in array
        {
            models.append(AZPrayerTimingModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let AZPrayerTimingModel = AZPrayerTimingModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZPrayerTimingModel Instance.
*/
	required public init?(dictionary: NSDictionary) {

		imsaak = dictionary["Imsaak"] as? String
		fajr = dictionary["Fajr"] as? String
		sunrise = dictionary["Sunrise"] as? String
		dhuhr = dictionary["Dhuhr"] as? String
		asr = dictionary["Asr"] as? String
		sunset = dictionary["Sunset"] as? String
		maghrib = dictionary["Maghrib"] as? String
		isha = dictionary["Isha"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.imsaak, forKey: "Imsaak")
		dictionary.setValue(self.fajr, forKey: "Fajr")
		dictionary.setValue(self.sunrise, forKey: "Sunrise")
		dictionary.setValue(self.dhuhr, forKey: "Dhuhr")
		dictionary.setValue(self.asr, forKey: "Asr")
		dictionary.setValue(self.sunset, forKey: "Sunset")
		dictionary.setValue(self.maghrib, forKey: "Maghrib")
		dictionary.setValue(self.isha, forKey: "Isha")

		return dictionary
	}

}
