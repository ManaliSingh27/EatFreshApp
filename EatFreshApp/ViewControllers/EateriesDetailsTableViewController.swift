//
//  EateriesDetailsTableViewController.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class EateriesDetailsTableViewController: UITableViewController {
    let utilityObject = Utility()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let eateriesDetailsAPIManager : EateriesDetailsAPIManager = EateriesDetailsAPIManager()
    
    var selectedEatery : Eatery?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        checkInternetConnectivityAndDownloadReviewsData()
    }
    
    
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (selectedEatery?.photos?.allObjects.count)!
        default:
            return (selectedEatery?.reviews?.allObjects.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return (selectedEatery?.photos?.allObjects.count)! > 0 ? "Images" : ""
        default:
            return (selectedEatery?.reviews?.allObjects.count)! > 0 ? "User Reviews" : ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! EateryDetailsTableViewCell
            configureDetailsCell(cell : cell)
            return cell
                
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! EateryImagesTableViewCell
            configureImagesCell(cell: cell, indexPath : indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! EateryUserReviewsTableViewCell
            let review : Review = selectedEatery?.reviews?.allObjects[indexPath.row] as! Review
            configureReviewsCell(cell : cell, review : review)
            let profilePhotoUrl =  review.profilePicUrl
            guard profilePhotoUrl != nil else
            {
                return cell
            }
            eateriesDetailsAPIManager.downloadPhotoImage(photoUrl:profilePhotoUrl! , completion: {
                (image) in
                DispatchQueue.main.async {
                    cell.authorProfilePicImageView.image = image
                }
            })
            return cell
        }
        
        
    }
    
   
    private func configureDetailsCell(cell : EateryDetailsTableViewCell)
    {
        cell.nameLabel.text = selectedEatery?.name
        cell.vicinityLabel.text = selectedEatery?.vicinity
        cell.openHrsLabel.text = ""
        if selectedEatery?.openHrs != nil {
            cell.openHrsLabel.text = (selectedEatery?.openHrs!.openNow)! ? "Open Now" : "Closed"
        }
    }
    
    private func configureImagesCell(cell : EateryImagesTableViewCell, indexPath : IndexPath)
    {
        let photos = selectedEatery?.photos?.allObjects
        let photo : Photos = photos?[indexPath.row] as! Photos
        let photoRef : String = photo.photoRef!
        let photoUrl =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(photo.width)&photoreference=\(photoRef)&key=\(Constants.PLACES_API_KEY)"
        eateriesDetailsAPIManager.downloadPhotoImage(photoUrl:photoUrl , completion: {
            (image) in
            DispatchQueue.main.async {
                cell.eateryImageView.image = image
            }
        })
    }
    
    private func configureReviewsCell(cell : EateryUserReviewsTableViewCell, review : Review)
    {
        cell.authorNameLabel.text = review.authorName
        let rating : Int = Int(review.rating)
        cell.ratingLabel.text = "Rating : \(rating)"
        cell.commentText.text = review.text
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension EateriesDetailsTableViewController
{
    
    // Checks Internet Connectivity and Downloads User Reviews Data from server
    private func checkInternetConnectivityAndDownloadReviewsData()
    {
        utilityObject.checkInternetConnectivity(completion: {
            [weak self] (result) in
            switch(result)
            {
            case true:
                DispatchQueue.main.async {
                    Utility.showActivityIndicatory(view: self!.view, activityIndicator: self!.activityIndicator)
                }
                self!.eateriesDetailsAPIManager.downloadReviewsData(vc:self!)
            case false:
                // self?.eateries = self!.eateriesDataManager.fetchEateries()
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Error", message: "There's no internet connection.", vc: self!)
                }
            }
        })
    }
}


class EateriesDetailsAPIManager
{
    /// Downloads image from the url
    /// - parameter photoUrl: url of image to be downloaded
    /// - parameter completion: completion handler
    func downloadPhotoImage(photoUrl : String, completion : @escaping (_ image : UIImage) -> Void)
    {
        let url = URL(string: photoUrl)
        let networkManager = NetworkManager(session: URLSession.shared)
        networkManager.downloadImageWithUrl(url: url!, completion: {
            (result) in
            switch(result)
            {
            case .Success(let image):
                completion(image)
            case .Error:
                print("placeholder image")
            }
        })
    }
    
    
    /// Downloads User Reviews Data from url
    /// - parameter vc: view controller calling the method
    func downloadReviewsData(vc:EateriesDetailsTableViewController)
    {
        let placeId = vc.selectedEatery!.placeId
        guard vc.selectedEatery?.placeId != nil else{
            return
        }
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId!)&fields=place_id,reviews&key=\(Constants.PLACES_API_KEY)"
        let placesUrl = URL(string: urlString)
        let networkManager = NetworkManager(session: URLSession.shared)
        networkManager.downloadData(url: placesUrl!, completion: {(result) in
            DispatchQueue.main.async {
                Utility.removeActivityIndicator(view: vc.view, activityIndicator: vc.activityIndicator)
            }
            switch(result)
            {
            case .Success(let data):
                DispatchQueue.main.async
                    {
                        do{
                            let decoder = JSONDecoder()
                            let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                            decoder.userInfo[CodingUserInfoKey.context!] = appDelegate.persistentContainer.viewContext
                            do{
                                let results : ReviewResults = try decoder.decode(ReviewResults.self, from: data)
                                print(results)
                                for review in results.result.reviews
                                {
                                    review.eatery = vc.selectedEatery
                                }
                                DataManager.shared.saveMainContext()
                                DispatchQueue.main.async{
                                    vc.tableView.reloadData()
                                }
                            }
                            catch{
                                print("Error")
                            }
                        }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Error", message: error, vc: vc)
                }
                
            }
        })
    }
}
