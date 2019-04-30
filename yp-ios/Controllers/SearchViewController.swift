//
//  SearchViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/13/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var places = [Place]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Communication.sharedInstance.serach(for: searchBar.text!) { (places) in
            self.places = places
            self.searchTableView.reloadData()
        }
        self.view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! HomeCell
        let place = places[indexPath.row]
        cell.ratingView.rating = place.rating
        cell.placeNameLbl.text = place.name
        cell.placePhoneLbl.text = place.phone
        if let logo = place.logo {
            cell.placeLogoIV.image = UIImage(named: logo)
        } else {
            cell.placeLogoIV.image = UIImage(named: "logo2")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = searchTableView.indexPathForSelectedRow
        
        let placeDetailsVC = segue.destination as! PlaceDetailsViewController
        placeDetailsVC.placeId = places[(indexPath?.row)!].id    }

}
