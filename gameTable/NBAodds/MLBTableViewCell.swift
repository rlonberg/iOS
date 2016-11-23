//
//  MLBTableViewCell.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/20/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

///
/// Customizes cell for companion table view controller
///
class MLBTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var awayPitcher: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var homePitcher: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var spread: UILabel!
    
    @IBOutlet weak var awaySpread: UILabel!
    @IBOutlet weak var homeSpread: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
