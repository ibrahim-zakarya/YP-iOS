//
//  PlaceDetailsViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/7/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import Cosmos
import Toast_Swift

class PlaceDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var placeId: Int!
    var place: Place!
    let activityIndicator = UIActivityIndicatorView()
    let darkView = UIView()
    let user = User.getUserInfo()
    
    @IBOutlet weak var commnetsTableView: UITableView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var logoIV: UIImageView!
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeSubtitleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var openTimeLbl: UILabel!
    @IBOutlet weak var closeTimeLbl: UILabel!
    @IBOutlet weak var detailsLbl: UITextView!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commnetsTableView.delegate = self
        commnetsTableView.dataSource = self
        
        addRating()
        fetchData()
        setupNavBar()
        setupLoadingControllers()
    }
    
    func addRating() {
        ratingView.didFinishTouchingCosmos = { rating in
            if let userId = self.user?.userId {
                Communication.sharedInstance.addRating(placeId: self.placeId, userId: userId, rating: rating)
            }
            else {
                self.showAlertBox(title: "Error", message: "You need to login first")
            }
            
        }
    }
    
    func setupLoadingControllers() {
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        
        darkView.backgroundColor = .black
        darkView.alpha = 0.5
        darkView.frame = view.frame
        
        view.addSubview(darkView)
        darkView.addSubview(activityIndicator)
    }
    
    func fetchData() {
        activityIndicator.startAnimating()
        Communication.sharedInstance.getPlaceDetails(placeId: placeId) { (place) in
            self.place = place
            self.commnetsTableView.reloadData()
            self.setupViewsContent()
            self.activityIndicator.stopAnimating()
            self.darkView.alpha = 0.0
        }
    }
    
    func setupViewsContent() {
        placeNameLbl.text = place.name
        addressLbl.text = place.address
        phoneLbl.text = place.phone
        mobileLbl.text = place.mobile
        websiteLbl.text = place.website
        openTimeLbl.text = place.openTime
        closeTimeLbl.text = place.closeTime
        detailsLbl.text = place.details
        ratingView.rating = place.rating
        placeSubtitleLbl.text = place.classification
        print(place.address)
        print(place.classification)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let place = self.place {
            return (place.comments?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commnetsTableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        if let comments = place.comments {
            let comment = comments[indexPath.row]
            cell.commentDate.text = comment.date
            cell.username.text = comment.userFullname
            cell.commentText.text = comment.text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func setupNavBar() {
        let barButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map-with-placeholder"), style: .plain, target: self, action: #selector(loadMapView))
        let barButton2 = UIBarButtonItem.init(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: #selector(addToFav))
        self.navigationItem.rightBarButtonItems = [barButton2, barButton]
    }
    
    @objc func loadMapView() {
        performSegue(withIdentifier: "showPlaceMap", sender: self)
    }
    
    @objc func addToFav() {
        
        if let userId = self.user?.userId {
            Communication.sharedInstance.addToFavorite(userId: userId, placeId: placeId) { (added, exist) in
                if added == false && exist == false {
                    self.view.makeToast("There is problem connecting to server1")
                    return
                } else if exist && added {
                    Communication.sharedInstance.removeFromFavorite(userId: 1, placeId: self.placeId, callback: { (status) in
                        if status {
                            self.navigationItem.rightBarButtonItems![0].image = #imageLiteral(resourceName: "heart")
                            self.view.makeToast("Removed from favorites")
                            return
                        } else {
                            self.view.makeToast("There is problem connecting to server2")
                            return
                        }
                    })
                } else if added && exist == false {
                    self.navigationItem.rightBarButtonItems![0].image = #imageLiteral(resourceName: "favorite")
                    self.view.makeToast("Added to favorite")
                }
                
            }
        } else {
            self.showAlertBox(title: "Error", message: "You need to login first")
        }
        
    }
    @IBAction func addCommentPressed(_ sender: UIButton) {
        
        if let userId = self.user?.userId, let text = commentTextView.text {
            Communication.sharedInstance.addComment(userId: userId, placeId: placeId, text: text)
            self.commentTextView.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! PlaceLocationViewController
        destVC.place = self.place
    }
}
