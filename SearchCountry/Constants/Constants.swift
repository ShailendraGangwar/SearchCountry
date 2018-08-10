//
//  Constants.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 07/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit

struct StringConstants {
    static let titleCountrySearchView = "Country Search"
    static let countryDetailsViewController = "CountryDetailsViewController"
    static let storyboardName = "Main"
    static let searchBarPlaceholder = "Search for a country..."
    static let countryTableViewCell = "countryTableViewCell"
    static let backButtonTitle = "Back"
    static let countryCapitalPretext = "Capital: "
    static let countryNamePretext = "Name: "
    static let countryNativeNamePretext = "Native name: "
    static let countryRegionPretext = "Region: "
    static let countryLanguagesPretext = "Languages: "
    static let countryTranslationsPretext = "Translations: "
}

struct CountriesRest {
    static let url = "https://restcountries.eu/rest/v2/name/"
}

struct CountryBaseModelKeysConstants {
    static let countryName = "name"
    static let countryCapital = "capital"
    static let countryRegion = "region"
    static let countryArea = "area"
    static let countryNativeName = "nativeName"
    static let countryLanguages = "languages"
    static let countryTranslations = "translations"
    static let countryFlag = "flag"
    static let countryLatitude = "latitude"
    static let countryLongitude = "longitude"
    static let countryLatLng = "latlng"
    static let countryTranslationToGerman = "de"
    static let countryLanguagesName = "name"
}

enum MathConstants {
    static let regionRadius: Double = 200000
    static let regionRadiusMultiplier = 2.0
    static let rowHeight: CGFloat  = 40
    static let overlayViewTag: Int = 2222
}

enum CountrySearchAppStoryboard: String {
    case Main = "Main"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
