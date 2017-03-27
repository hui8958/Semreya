//
//  ParcelDetailTableViewCell.swift
//  Semreya
//
//  Created by Hui on 2017-01-12.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit

class ParcelDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var location: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
