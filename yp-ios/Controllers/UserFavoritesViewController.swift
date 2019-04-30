//
//  UserFavoritesViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/16/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit

class UserFavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoritesTabelView: UITableView!
    var places = [Place]()
    private let refreshControl = UIRefreshControl()
    let ai = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesTabelView.delegate = self
        favoritesTabelView.dataSource = self
        setupRefreshControllers()
        fetchData()
        navigationItem.title = "My Favorites"
        
        setupRefreshControllers()
    }
    
    func setupRefreshControllers() {
        favoritesTabelView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.color = .darkGray
        self.view.addSubview(ai)
    }
    
    @objc func fetchData() {
        ai.startAnimating()
        Communication.sharedInstance.getUserFavorite(userId: 1) { (places) in
            self.places = places
            self.refreshControl.endRefreshing()
            self.favoritesTabelView.reloadData()
            self.ai.stopAnimating()
        }
    }
    
    @objc func updateData() {
        Communication.sharedInstance.getUserFavorite(userId: 1) { (places) in
            self.places = places
            self.refreshControl.endRefreshing()
            self.favoritesTabelView.reloadData()
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTabelView.dequeueReusableCell(withIdentifier: "favCell") as! HomeCell
        let place = places[indexPath.row]
        cell.placeAddressLbl.text = place.address
        cell.placeNameLbl.text = place.name
        if let logo = place.logo {
            cell.placeLogoIV.image = UIImage(named: logo)
        } else {
            cell.placeLogoIV.image = UIImage(named: "logo2")
        }
        cell.placePhoneLbl.text = place.phone
        cell.ratingView.rating = place.rating
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showFavoriteDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = favoritesTabelView.indexPathForSelectedRow
        
        let placeDetailsVC = segue.destination as! PlaceDetailsViewController
        placeDetailsVC.placeId = places[(indexPath?.row)!].id
    }

}
