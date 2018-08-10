//
//  CountriesAPIServiceManager.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 04/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation

/*
 * This class is responsible for
 * 1. making http request
 * 2. Parse data using Jsonserialization
 * 3. Handle http url response
 */
class CountriesAPIServiceManager {

    /// Provides singleton sccess to CountriesAPIServiceManager
    private static var sharedServiceManager: CountriesAPIServiceManager = {
        let networkManager = CountriesAPIServiceManager()
        return networkManager
    }()

    /**
     Returns shared instance of CountriesAPIServiceManager

     @return CountriesAPIServiceManager Shared instance.
     */
    class func shared() -> CountriesAPIServiceManager {
        return sharedServiceManager
    }

    /**
     Get countries with substring in their name using NSURLSession
     akdjalkjd

     @param subString Substring to be used to get countries list
     */
    func getCountriesWithSubstring(subString: String) {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(CountriesRest.url)\(subString)")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                CountryDataManager.shared().saveCountriesList(newCountrylist: [])
                print(error!.localizedDescription)
            } else {
                self.parseDataWith(response: response!, data: data!)
            }
        })
        task.resume()
    }

    /**
     Parse the data received from REST API based on URL response. It also asks Datamanager to model the data recieved.

     @param response URL Response

     @param data Data received
     */
    func parseDataWith(response: URLResponse, data: Data) {
        let httpResponse = response as? HTTPURLResponse
        switch(httpResponse?.statusCode) {
        case 200?:
            do {
                let someDictionaryFromJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
                CountryDataManager.shared().saveCountriesList(newCountrylist: someDictionaryFromJSON!)
            } catch {
                print("error in JSONSerialization")
            }
        case 404?:
            print("Not found")
            CountryDataManager.shared().saveCountriesList(newCountrylist: [])
        default:
            print("Nothing")
        }
    }
}
