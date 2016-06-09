//
//  FIFATableViewCell.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/25/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

///
/// Customizes cell for companion table view controller
///
class FIFATableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dateDescription: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    
    @IBOutlet weak var homeTeam: UILabel!

    @IBOutlet weak var spread: UILabel!
    @IBOutlet weak var visitingSpread: UILabel!
    @IBOutlet weak var homeSpread: UILabel!
    
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
