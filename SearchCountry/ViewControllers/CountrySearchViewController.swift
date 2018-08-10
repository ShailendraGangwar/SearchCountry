//
//  CountrySearchViewController.swift
//  SearchCountry
//
//  Created by Shailendra Gangwar on 04/Nov/2017.
//  Copyright © 2017 Shailendra Gangwar. All rights reserved.
//

import UIKit

/**
 This class is responsible for showing country list based on search string.
 */
final class CountrySearchViewController: UIViewController {

    // MARK: - IBOutlets
    // MARK: -

    //Tableview for showing searched countries list
    @IBOutlet weak var countryTableSearchResults: UITableView!

    // MARK: - Variables
    // MARK: -

    ///Filtered array list with countries received
    var countryListFilteredArray = NSMutableArray()
    ///Custom search controller in table header where user search for country
    var customSearchController: UISearchController!
    ///Delegate helper for CountrySearchViewHelper
    fileprivate let countryListPresenter = CountrySearchViewHelper()

    // MARK: - Life cycle methods
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set title of the view
        self.title = StringConstants.titleCountrySearchView
        //Setting delegate for countryListPresenter
        self.countryListPresenter.attachView(view: self)
        //Setting datasource and delegate for tableview
        self.countryTableSearchResults.delegate = self
        self.countryTableSearchResults.dataSource = self
        //Configure search controller
        self.configureSearchController()
    }

    // MARK: - Custom methods
    // MARK: -

    /**
     Configures UISearchController.
     */
    private func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        self.customSearchController = UISearchController(searchResultsController: nil)
        self.customSearchController.searchResultsUpdater = self
        self.customSearchController.dimsBackgroundDuringPresentation = true
        self.customSearchController.searchBar.placeholder = StringConstants.searchBarPlaceholder
        self.customSearchController.searchBar.delegate = self
        self.customSearchController.searchBar.sizeToFit()
        self.customSearchController.hidesNavigationBarDuringPresentation = false
        // Place the search bar view to the tableview headerview.
        self.countryTableSearchResults.tableHeaderView = customSearchController.searchBar
    }

    /**
     Stops spinner view on Country search view.
     */
    private func hideSpinnerView() {
        SpinnerView().hideOverlayView(view: self.view)
    }

    /**
     Shows spinner view on Country search view.
     */
    private func showSpinnerView() {
        SpinnerView().showOverlayOn(view: self.view)
    }
}

// MARK: - UITableViewDataSource
// MARK: -

extension CountrySearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryListFilteredArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.countryTableViewCell, for: indexPath)
        let countryBaseModelAtCurrentIndexPath = countryListFilteredArray[indexPath.row] as? CountryBaseModel
        cell.selectionStyle = .gray
        cell.textLabel?.text = countryBaseModelAtCurrentIndexPath?.name
        return cell
    }
}

// MARK: - UITableViewDelegate
// MARK: -

extension CountrySearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MathConstants.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSelectedCountry = self.countryListFilteredArray[indexPath.row]
        let storyBoard: UIStoryboard = CountrySearchAppStoryboard.Main.instance
        let countryDetailsViewController = storyBoard.instantiateViewController(withIdentifier: StringConstants.countryDetailsViewController) as? CountryDetailsViewController
        countryDetailsViewController?.currentSelectedCountryDetails = currentSelectedCountry as? CountryBaseModel
        self.navigationController?.pushViewController(countryDetailsViewController!, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
// MARK: -

extension CountrySearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text, searchString != "" else {
            return
        }
        self.showSpinnerView()
        self.countryListPresenter.getCountriesWithSubstring(countryNameSubstring: searchString)
    }
}

// MARK: - UISearchBarDelegate
// MARK: -

extension CountrySearchViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.countryListFilteredArray.removeAllObjects()
        self.countryTableSearchResults.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.customSearchController.searchBar.resignFirstResponder()
    }
}

// MARK: - CountrySearchHelperDelegate
// MARK: -

extension CountrySearchViewController: CountrySearchHelperDelegate {

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

    func setCountries(countries: NSMutableArray) {
        self.countryListFilteredArray.removeAllObjects()
        self.countryListFilteredArray = countries
        DispatchQueue.main.async {
            self.countryTableSearchResults.reloadData()
        }
    }
}
