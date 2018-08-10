//
//  CountryBaseModel.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 05/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation

 public class CountryBaseModel {
    var name: String?
    var capital: String?
    var region: String?
    var latlng: Dictionary<String, Double>?
    var area: String?
    var nativeName: String?
    var languages: String?
    var translations: String?
    var flag: String?

    /**
     Initializer mehod.

     @param dictionary dictionary of country
     */
    init(dictionary: Dictionary<String, Any>) {

        self.name = dictionary[CountryBaseModelKeysConstants.countryName] as? String
        self.capital = dictionary[CountryBaseModelKeysConstants.countryCapital] as? String
        self.region = dictionary[CountryBaseModelKeysConstants.countryRegion] as? String
        self.area = dictionary[CountryBaseModelKeysConstants.countryArea] as? String
        self.nativeName = dictionary[CountryBaseModelKeysConstants.countryNativeName] as? String
        self.flag = dictionary[CountryBaseModelKeysConstants.countryFlag] as? String

        if (dictionary[CountryBaseModelKeysConstants.countryLanguages] != nil) {
            let languagesArray = dictionary[CountryBaseModelKeysConstants.countryLanguages] as? [Dictionary<String, Any>]
            let langArray = NSMutableArray()
            for item: Dictionary in languagesArray! {
                langArray.add(item[CountryBaseModelKeysConstants.countryLanguagesName] ?? "")
            }
            self.languages = langArray.componentsJoined(by: ", ")
        }

        if (dictionary[CountryBaseModelKeysConstants.countryTranslations] != nil) {
            let translationDict = dictionary[CountryBaseModelKeysConstants.countryTranslations] as? Dictionary<String, Any>
            if translationDict![CountryBaseModelKeysConstants.countryTranslationToGerman] != nil {
                self.translations = (translationDict![CountryBaseModelKeysConstants.countryTranslationToGerman].map { "\($0) (\(CountryBaseModelKeysConstants.countryTranslationToGerman))"} ?? "")
            }
        }

        if let latlngArray = (dictionary[CountryBaseModelKeysConstants.countryLatLng] as? NSArray), latlngArray.count == 2 {
            self.latlng = [CountryBaseModelKeysConstants.countryLatitude: latlngArray[0] as! Double, CountryBaseModelKeysConstants.countryLongitude: latlngArray[1] as! Double]
        } else {
            self.latlng = [CountryBaseModelKeysConstants.countryLatitude: 20, CountryBaseModelKeysConstants.countryLongitude: 77] //default value
        }
    }

    /**
     Converts each item in countries list to country base model

     @param countriesList Array of countries

     @return Array od country base models
     */
    public class func getCountryArrayWithModels(countriesList: NSArray) -> NSArray {
        let countryArray = NSMutableArray()
        for country in countriesList {
            countryArray.add(CountryBaseModel(dictionary: (country as? Dictionary)!))
        }
        return countryArray
    }

}
