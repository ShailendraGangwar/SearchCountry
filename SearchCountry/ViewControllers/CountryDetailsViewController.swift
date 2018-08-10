//
//  CountryDetailsViewController.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 04/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class CountryDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    // MARK: -

    @IBOutlet weak var countryFlagView: UIView!
    @IBOutlet weak var countryTranslations: UILabel!
    @IBOutlet weak var countryLanguages: UILabel!
    @IBOutlet weak var countryCapital: UILabel!
    @IBOutlet weak var countryRegion: UILabel!
    @IBOutlet weak var countryNativeName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryLatLngMapView: MKMapView!

    // MARK: - Variables
    // MARK: -

    /// Current country details
    var currentSelectedCountryDetails: CountryBaseModel?
    /// delegate helper for CountrySearchViewHelper
    fileprivate let countryListPresenter = CountrySearchViewHelper()

    // MARK: - Life cycle methods
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setDefaultBackgroundColor()
        self.countryListPresenter.attachView(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTextOnLabelsWithCountryDetails()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.countryListPresenter.detachView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSpinnerView()
        if let countryFlagImgUrlStr =  currentSelectedCountryDetails?.flag, let svgURL = URL(string:countryFlagImgUrlStr) {
            self.countryListPresenter.downloadFlagWithSVGImg(url: svgURL, onView: self.countryFlagView)
        }
    }

    // MARK: - Private methods
    // MARK: -

    /**
     Update all the label text with country details
     */
    func updateTextOnLabelsWithCountryDetails() {
        self.countryCapital.text = StringConstants.countryCapitalPretext + (currentSelectedCountryDetails?.capital)!
        self.countryName.text = StringConstants.countryNamePretext + (currentSelectedCountryDetails?.name)!
        self.countryNativeName.text = StringConstants.countryNativeNamePretext + (currentSelectedCountryDetails?.nativeName)!
        self.countryRegion.text = StringConstants.countryRegionPretext + (currentSelectedCountryDetails?.region)!
        self.countryLanguages.text = StringConstants.countryLanguagesPretext + (currentSelectedCountryDetails?.languages)!
        if let latitude = self.currentSelectedCountryDetails?.latlng?[CountryBaseModelKeysConstants.countryLatitude], let longitude = self.currentSelectedCountryDetails?.latlng?[CountryBaseModelKeysConstants.countryLongitude] {
            let countryLocation = CLLocation(latitude: latitude, longitude: longitude)
            self.centerMapOnCountryLocation(location: countryLocation)
        }
        self.countryTranslations.text = StringConstants.countryTranslationsPretext + (self.currentSelectedCountryDetails?.translations!)!
    }

    /**
     Set centre map on location provided.

     @param location CLLocation with latitude and longitude
     */
    func centerMapOnCountryLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = MathConstants.regionRadius
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * MathConstants.regionRadiusMultiplier, regionRadius * MathConstants.regionRadiusMultiplier)
        self.countryLatLngMapView.setRegion(coordinateRegion, animated: true)
    }

    /**
     Hides spinner view from country details view
     */
    private func hideSpinnerView() {
        SpinnerView().hideOverlayView(view: self.view)
    }

    /**
     Shows spinner view on Country details view.
     */
    private func showSpinnerView() {
        SpinnerView().showOverlayOn(view: self.view)
    }

    /**
     Set default color for background view and countryFlagView
     */
    private func setDefaultBackgroundColor() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.countryFlagView.backgroundColor = UIColor.clear
    }

    /**
     Set navigation bar title and back button title
     */
    private func setNavigationBar() {
        self.title = self.currentSelectedCountryDetails?.name
        let backButton = UIBarButtonItem()
        backButton.title = StringConstants.backButtonTitle
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

extension CountryDetailsViewController: CountrySearchHelperDelegate {
    func startLoading() {
        DispatchQueue.main.async {
            self.showSpinnerView()
        }
    }

    func finishLoading() {
        DispatchQueue.main.async {
            self.hideSpinnerView()
        }
    }
}
