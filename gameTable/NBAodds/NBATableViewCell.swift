//
//  NBATableViewCell.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/18/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

///
/// Customizes cell for companion table view controller
///
class NBATableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var date: UILabel!
    //@IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    //@IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var spread: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var visitingSpread: UILabel!
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
