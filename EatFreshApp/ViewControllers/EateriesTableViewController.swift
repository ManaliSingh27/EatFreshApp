//
//  EateriesTableViewController.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 16/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EateriesTableViewController: UITableViewController {
    
    var locationManager = CLLocationManager()
    let utilityObject = Utility()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var selectedEatery : Eatery?
    let eateriesDataManager : EateriesDataManager = EateriesDataManager()
    let eateriesAPIManager : EateriesAPIManager = EateriesAPIManager()
    let searchController = UISearchController(searchResultsController: nil)
    let eateriesRefreshControl : UIRefreshControl = UIRefreshControl()
    
    var filteredEateries: [Eatery] = []
    
    var eateries: [Eatery] = [] {
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
    }
    
    
    // Configures the View
    private func configureView()
    {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        eateriesRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        eateriesRefreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(eateriesRefreshControl)
    }
    
    // MARK: - Pull To Refresh Method
    /// Refreshes Data on Pull To Refresh
    @objc func refreshData(refreshControl: UIRefreshControl) {
        locationManager.requestLocation()
        eateriesRefreshControl.endRefreshing()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredEateries.count : eateries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EateryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EateryTableViewCell
        guard eateries.count > indexPath.row
            else
        {
            return cell
        }
        let eatery : Eatery = isFiltering ? filteredEateries[indexPath.row] : eateries[indexPath.row]
        
        cell.eateryNameLabel.text = eatery.name
        cell.openLabel.text = ""
        if eatery.openHrs != nil {
            cell.openLabel.text = eatery.openHrs!.openNow ? "Open Now" : "Closed"
        }
        cell.ratingsLabel.text = "Avg Rating : \(String(eatery.rating))"
        if eatery.iconUrl != nil {
            eateriesAPIManager.downloadPhotoImage(photoUrl:eatery.iconUrl!  , completion: {
                (image) in
                DispatchQueue.main.async {
                    cell.iconImageView.image = image
                }
            })
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEatery = isFiltering ? filteredEateries[indexPath.row] : eateries[indexPath.row]
        performSegue(withIdentifier: "showDetailsSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC : EateriesDetailsTableViewController = segue.destination as! EateriesDetailsTableViewController
        destinationVC.selectedEatery = selectedEatery!
    }
    
    // MARK: - Filter Search Text
    // Filters the results based on the Search Text
    /// - parameter searchText: text to filter results
    func filterContentForSearchText(_ searchText: String) {
        filteredEateries = eateries.filter { (eatery: Eatery) -> Bool in
            return eatery.name!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
}

extension EateriesTableViewController : CLLocationManagerDelegate, UISearchResultsUpdating
{
    // MARK: - Search Bar Delegates
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    // MARK: - Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationsArray = locations as NSArray
        let locationObject = locationsArray.lastObject as? CLLocation
        if (locationObject != nil) {
            checkInternetConnectivityAndDownloadRestaurantsData(latitude : (locationObject?.coordinate.latitude)! , longitude :(locationObject?.coordinate.longitude)! )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Utility.showAlert(title: "Error", message: error.localizedDescription, vc: self)
        
    }
    
    // MARK: - Internet Connectivity Check to Download Eateries Data
    /// Checks internet connectivity and Download Eateries from server
    /// - parameter latitude: Latitude cordinate
    /// - parameter longitude: Longitude Cordinate
    
    private func checkInternetConnectivityAndDownloadRestaurantsData(latitude:CLLocationDegrees, longitude:CLLocationDegrees)
    {
        utilityObject.checkInternetConnectivity(completion: {
            [weak self] (result) in
            switch(result)
            {
            case true:
                DispatchQueue.main.async {
                    Utility.showActivityIndicatory(view: self!.view, activityIndicator: self!.activityIndicator)
                }
                self!.eateriesAPIManager.downloadEateriesData(latitude: latitude, longitude: longitude, vc:self!)
            case false:
                self?.eateries = self!.eateriesDataManager.fetchEateries()
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Error", message: "There's no internet connection.", vc: self!)
                }
            }
        })
    }
    
    
    
    
}

class EateriesDataManager
{
    // MARK: - Database Operations
    
    /// Fetches all the eateies from database
    /// - returns: Array of Eateries
    func fetchEateries() -> [Eatery]
    {
        let eateries = DataManager.shared.fetchEateries()
        return eateries
    }
}


class EateriesAPIManager
{
    /// Downloads Eateries data
    /// - parameter latitude: latitude cordinate
    /// - parameter longitude: longitude cordinate
    func downloadEateriesData(latitude:CLLocationDegrees, longitude:CLLocationDegrees, vc:EateriesTableViewController)
    {
        
        /*   let path = Bundle.main.path(forResource: "Test", ofType: "json")
         do{
         let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
         parseAndSaveData(data: data, vc:vc)
         }
         catch{
         
         }*/
        
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1500&type=restaurant&key=\(Constants.PLACES_API_KEY)"
        let placesUrl = URL(string: urlString)
        let networkManager = NetworkManager(session: URLSession.shared)
        networkManager.downloadData(url: placesUrl!, completion: {[weak self](result) in
            DispatchQueue.main.async {
                Utility.removeActivityIndicator(view: vc.view, activityIndicator: vc.activityIndicator)
            }
            switch(result)
            {
            case .Success(let data):
                DispatchQueue.main.async
                    {
                        do{
                            self!.parseAndSaveData(data: data, vc:vc)
                            
                        }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Error", message: error, vc: vc)
                }
            }
        })
    }
    
    
    private func parseAndSaveData(data : Data, vc:EateriesTableViewController)
    {
        DataManager.shared.clearStorage()
        let decoder = JSONDecoder()
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        decoder.userInfo[CodingUserInfoKey.context!] = appDelegate.persistentContainer.viewContext
        do{
            let results = try decoder.decode(Results.self, from: data)
            print(results)
            
            DataManager.shared.saveMainContext()
            vc.eateries = (vc.eateriesDataManager.fetchEateries())
        }
        catch{
            print("Error")
        }
    }
    
    /// Downloads Photo from the url
    /// - parameter photoUrl: url from when image is to be downloaded
    /// - parameter completion: Completion handler
    public func downloadPhotoImage(photoUrl : String, completion : @escaping (_ image : UIImage) -> Void)
    {
        let url = URL(string: photoUrl)
        let networkManager = NetworkManager(session: URLSession.shared)
        guard url != nil else
        {
            return
        }
        networkManager.downloadImageWithUrl(url: url!, completion: {
            (result) in
            switch(result)
            {
            case .Success(let image):
                completion(image)
            case .Error:
                print("placeholder image")
                // show placeholder image
            }
        })
    }
}
