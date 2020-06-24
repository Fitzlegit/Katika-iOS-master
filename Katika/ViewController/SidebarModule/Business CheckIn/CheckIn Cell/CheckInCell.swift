//
//  CheckInCell.swift
//  Katika
//
//  Created by Apple on 23/11/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit
import Cosmos


class CheckInCell: UITableViewCell {

    @IBOutlet weak var viewReview: CosmosView!
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCheckInTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
