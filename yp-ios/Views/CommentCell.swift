//
//  CommentCell.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/9/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
