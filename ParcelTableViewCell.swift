//
//  ParcelTableViewCell.swift
//  Semreya
//
//  Created by Hui on 2017-01-11.
//  Copyright © 2017 Hui. All rights reserved.
//

import UIKit

class ParcelTableViewCell: UITableViewCell {

    @IBOutlet weak var recentTime: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var recentLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
