//
//  EateriesDetailsTableViewController.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class EateriesDetailsTableViewController: UITableViewController {
    
    var selectedEatery : Eatery?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (selectedEatery?.photos?.allObjects.count)! + 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! EateryDetailsTableViewCell
            cell.nameLabel.text = selectedEatery?.name
            cell.vicinityLabel.text = selectedEatery?.vicinity
            cell.openHrsLabel.text = ""
            if selectedEatery?.openHrs != nil {
                cell.openHrsLabel.text = (selectedEatery?.openHrs!.openNow)! ? "Open Now" : "Closed"
            }
            let rating  = selectedEatery?.userRatingTotal
            cell.userReviewsLabel.text = String(rating!) + " User Reviews "
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! EateryImagesTableViewCell
            let photos = selectedEatery?.photos?.allObjects
            let photo : Photos = photos?[indexPath.row - 1] as! Photos
            let photoRef : String = photo.photoRef!
            let photoUrl =  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(photo.width)&photoreference=\(photoRef)&key=\(Constants.PLACES_API_KEY)"
            downloadPhotoImage(photoUrl:photoUrl , completion: {
                (image) in
                DispatchQueue.main.async {
                    cell.eateryImageView.image = image
                }
            })
            return cell
        }
        
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
    /// Downloads image from the url
    /// - parameter photoUrl: url of image to be downloaded
    /// - parameter completion: completion handler
    private func downloadPhotoImage(photoUrl : String, completion : @escaping (_ image : UIImage) -> Void)
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
    
}
