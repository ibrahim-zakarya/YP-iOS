//
//  HomeCell.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/7/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import Cosmos

class HomeCell: UITableViewCell {
    
    
    @IBOutlet weak var placeLogoIV: UIImageView!
    @IBOutlet weak var placeAddressLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var placePhoneLbl: UILabel!
    @IBOutlet weak var placeNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
