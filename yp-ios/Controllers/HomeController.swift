//
//  HomeController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/5/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import Cosmos

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var homeTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    var places = [Place]()
    
    let ai = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        setupRefreshControllers()
        fetchData()
        navigationItem.title = "Home"
        let sendMessagebarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "mail"), style: .plain, target: self, action: #selector(openSendMessage))
        self.navigationItem.rightBarButtonItems = [sendMessagebarButton]
    }
    
    func setupRefreshControllers() {
        homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.color = .darkGray
        self.view.addSubview(ai)
    }
    
    @objc func fetchData() {
        ai.startAnimating()
        Communication.sharedInstance.getAllPlaces { (places) in
            self.places = places
            self.homeTableView.reloadData()
            self.ai.stopAnimating()
        }
    }
    
    @objc func updateData() {
        Communication.sharedInstance.getAllPlaces { (places) in
            self.places = places
            self.refreshControl.endRefreshing()
            self.homeTableView.reloadData()
        }
    }
    
    @objc func openSendMessage() {
        performSegue(withIdentifier: "showMessage", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showPlaceDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessage" {
            return
        }
        let indexPath = homeTableView.indexPathForSelectedRow
        
        let placeDetailsVC = segue.destination as! PlaceDetailsViewController
        placeDetailsVC.placeId = places[(indexPath?.row)!].id
    }

}

