//
//  NBATableViewController.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/18/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

///
/// Populates table with event information pulled from companion downloader
///
class NBATableViewController: UITableViewController {
    
    var slate:[NBAdownloader.Game] = [] {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(NBATableViewController.refreshSlate), forControlEvents: UIControlEvents.ValueChanged)
        
        refreshSlate()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @IBAction func refreshSlate() {
        
        let refreshOperation = NSBlockOperation(block: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let downloader = NBAdownloader()
            self.slate = downloader.returnSlate()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        refreshOperation.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshControl?.endRefreshing()
            })
        }
        
        refreshControl?.beginRefreshing()
        NSOperationQueue().addOperation(refreshOperation)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard slate.count != 0 else {
            return 0
        }
        return slate.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NbaCell"
        
        let game = slate[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NBATableViewCell
        
        cell.date.text = game.datetime.componentsSeparatedByString("+")[0]
        if (game.datetime.componentsSeparatedByString("+")[0]).rangeOfString(" 0:") != nil {
            cell.date.text = cell.date.text?.stringByReplacingOccurrencesOfString(" 0:", withString: " 12:")
        }
        
        cell.visitingSpread.text = ""//"(" + String(game.spread) + ")"
        cell.homeSpread.text = ""//"(" + String(-1*game.spread) + ")"
        if game.spread < 0 {
            // visitors
            cell.spread.text = game.away.componentsSeparatedByString(" ").last! + " favored by " + String(abs(game.spread))
        } else {
            // home
            cell.spread.text = game.home.componentsSeparatedByString(" ").last! + " favored by " + String(abs(game.spread))
        }
        
        if game.spread < -99.0 {
            cell.spread.text = "(vegas has not yet set a spread)"
        }
        
        // refactor this later
        cell.awayImage.image = UIImage(named: returnPNG(game.home))
        cell.homeImage.image = UIImage(named: returnPNG(game.away))
        //cell.awayImage.image = UIImage(named: game.away)
        //cell.homeImage.image = UIImage(named: game.home)
        
        
        cell.awayTeam.text = game.away
        cell.homeTeam.text = "at " + game.home
        
        
        return cell
        
        
    }
    
    func returnPNG(team: String) -> String {
        
        switch team {
        case "Indiana Pacers":
            return "georgePNG"
            
        case "Toronto Raptors":
            let options = ["derozanPNG","lowryPNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Dallas Mavericks":
            return "dirkPNG"
            
        case "Oklahoma City Thunder":
            return "westbrookPNG"
            
        case "Houston Rockets":
            return "hardenPNG"
            
        case "Golden State Warriors":
            let options = ["curryPNG","draymondPNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Boston Celtics":
            return "smartPNG"
            
        case "Atlanta Hawks":
            let options = ["horfordPNG","bazemorePNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Memphis Grizzlies":
            return "vincePNG"
            
        case "San Antonio Spurs":
            let options = ["kawhiPNG","duncanPNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Charlotte Hornets":
            return "kembaPNG"
            
        case "Miami Heat":
            let options = ["wadePNG","winslowPNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Detroit Pistons":
            return "drummondPNG"
            
        case "Cleveland Cavaliers":
            let options = ["lebronPNG","kyriePNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Portland Trail Blazers":
            let options = ["lillardPNG","cjPNG"]
            return options[Int(arc4random_uniform(6) + 1)%2]
            
        case "Los Angeles Clippers":
            return "cp3PNG"
            
        case "Chicago Bulls":
            return "butlerPNG"
        
        case "Washington Wizards":
            let options = ["wallPNG", "bealPNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
        
        case "Orlando Magic":
            let options = ["gordon_dunkPNG", "vukevicPNG", "gordonPNG"]
            return options[Int(arc4random_uniform(6)+1)%3]
            
        case "Milwaukee Bucks":
            let options = ["giannisPNG", "jabariPNG", "middletonPNG"]
            return options[Int(arc4random_uniform(6)+1)%3]
            
        case "New York Knicks":
            let options = ["carmeloPNG", "porzingisPNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
            
        case "Brooklyn Nets":
            return "lopezPNG"
            
        case "Philadelphia 76ers":
            return "butlerPNG"
        
        case "Utah Jazz":
            let options = ["gobertPNG", "favorsPNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
            
        case "Sacramento Kings":
            let options = ["cousinsPNG", "mclemorePNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
            
        case "Denver Nuggets":
            let options = ["jokicPNG", "mudiayPNG", "fariedPNG"]
            return options[Int(arc4random_uniform(6)+1)%3]
            
        case "New Orleans Pelicans":
            let options = ["anthonyPNG", "ADPNG", "davisPNG"]
            return options[Int(arc4random_uniform(6)+1)%3]
            
        case "Minnesota Timberwolves":
            let options = ["townsPNG", "wigginsPNG", "lavinePNG"]
            return options[Int(arc4random_uniform(6)+1)%3]
            
        case "Phoenix Suns":
            let options = ["knightPNG", "bookerPNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
            
        case "Los Angeles Lakers":
            let options = ["russellPNG", "randlePNG"]
            return options[Int(arc4random_uniform(6)+1)%2]
            
        default:
            return "default"
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
