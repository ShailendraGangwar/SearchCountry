//
//  CountrySearchViewHelper.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 08/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit
import SwiftSVG

@objc protocol CountrySearchHelperDelegate: NSObjectProtocol {
    /**
     Show the spinner to show something happening on background
     */
    func startLoading()

    /**
     Stop the spinner to show background task is over
     */
    func finishLoading()

    /**
     Provides the list of countries array

     @param countries Array of countries.
     */
    @objc optional func setCountries(countries: NSMutableArray)
}

class CountrySearchViewHelper {

    ///Delegate helper for CountryListUpdateDelegate
    var countryListUpdateDelegate = CountryDataManager.shared()
    ///Delegate helper for country search view and country detail view
    weak fileprivate var countryListView: CountrySearchHelperDelegate?

    /**
     Initializer method
     */
    init() {
        self.countryListUpdateDelegate.delegate = self
    }

    /**
     Setting the view delegate.

     @param view delegate from delegator
     */
    func attachView(view: CountrySearchHelperDelegate) {
        self.countryListView = view
    }

    /**
     Removing the view delegate.
     */
    func detachView() {
        self.countryListView = nil
    }

    /**
     Request API service to get countries with having substring in their name.

     @param countryNameSubstring Consectetur adipisicing elit.
     */
    func getCountriesWithSubstring(countryNameSubstring: String) {
        self.countryListView?.startLoading()
        CountriesAPIServiceManager.shared().getCountriesWithSubstring(subString: countryNameSubstring)
    }

    /**
     Download the Country flag image which is in svg format.

     @param url SVG flag image url

     @param onView View on which svg image should be placed.
     */
    func downloadFlagWithSVGImg(url: URL, onView: UIView) {
        DispatchQueue.main.async {
            let flagImageLayer = UIView(SVGURL: url) {[weak self] (svgLayer) in
                svgLayer.resizeToFit(onView.bounds)
                self?.countryListView?.finishLoading()
            }
            onView.addSubview(flagImageLayer)
        }
    }
}

extension CountrySearchViewHelper: CountryListUpdateDelegate {

    func countriesUpdated() {
        self.countryListView?.finishLoading()
        self.countryListView?.setCountries!(countries: CountryDataManager.shared().countriesList)
    }
}
