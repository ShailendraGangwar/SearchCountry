//
//  CountryDataManager.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 05/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation

protocol CountryListUpdateDelegate: class {
    /**
     Notify about updated filtered countries list received.
     */
    func countriesUpdated()
}

/*
 * This singleton class is reponsible
 * 1. parsing json in CountryBaseModel
 * 2. provide global access point for countries received from API
 */
class CountryDataManager: NSObject {

    /// Array of filtered countries
    public var countriesList = NSMutableArray()
    //delegate for CountryListUpdateDelegate
    weak var delegate: CountryListUpdateDelegate?

    /// Provides singleton sccess to CountryDataManager
    private static var sharedDataManager: CountryDataManager = {
        let dataManager = CountryDataManager()
        return dataManager
    }()

    /**
     Provides shared instance

     @return CountryDataManager shared instance of CountryDataManager.
     */
    class func shared() -> CountryDataManager {
        return sharedDataManager
    }

    /**
     Save countries list and notify using delegate

     @param newCountrylist Array of new countries received
     */
    func saveCountriesList(newCountrylist: NSArray) {
        self.countriesList.removeAllObjects()
        self.countriesList = (CountryBaseModel.getCountryArrayWithModels(countriesList: newCountrylist) as? NSMutableArray)!
        delegate?.countriesUpdated()
    }

}
