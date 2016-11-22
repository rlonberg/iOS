//
//  TestTableViewController.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/15/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

///
/// Populates table with event information pulled from companion downloader
///
class FIFATableViewController: UITableViewController {
    
    let sectionTitles:[String] = ["English Premier League", "Bundesliga", "Serie A", "La Liga", "MLS"]
    
    
    var slate:[[FIFAdownloader.Game]] = [] {
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
        refreshControl!.addTarget(self, action: #selector(FIFATableViewController.refreshFIFAslate), forControlEvents: UIControlEvents.ValueChanged)
        
        
        refreshFIFAslate()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    ///
    /// action outlet from refreshControl
    ///
    @IBAction func refreshFIFAslate() {
        
        let refreshOperation = NSBlockOperation(block: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let downloader = FIFAdownloader()
            self.slate = downloader.lightningReturnSlate() // changed from returnSlate to lightningReturnSlate
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        refreshOperation.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), { self.refreshControl?.endRefreshing()
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
        return FIFAfilter.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard slate.count != 0 else {
            return 0
        }
        return slate[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FIFAfilter[section]
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let game = slate[indexPath.section][indexPath.row]
        
        let cellIdentifier = "FifaTableCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FIFATableViewCell
        
        cell.date.text = game.datetime.componentsSeparatedByString("+")[0]
        cell.dateDescription.text = game.datetime.componentsSeparatedByString("+")[1]
        if cell.date.text?.componentsSeparatedByString(" ")[2][0] == "0" {
            cell.date.text = game.datetime.componentsSeparatedByString("+")[0].componentsSeparatedByString(" ")[0] + " " + game.datetime.componentsSeparatedByString("+")[0].componentsSeparatedByString(" ")[1] + " 12:" + game.datetime.componentsSeparatedByString("+")[0].componentsSeparatedByString(" ")[2].componentsSeparatedByString(":")[1]
        }
        
        // refactor later
        cell.awayTeam.text = game.home
        cell.homeTeam.text = "vs " + game.away
        cell.awayImage.image = UIImage(named: game.away)
        cell.homeImage.image = UIImage(named: game.home)
        
        
        if game.spread < -900.0 {
            cell.spread.text = "no spread set for match"
            cell.visitingSpread.text = ""
            cell.homeSpread.text = ""
        } else {
            cell.spread.text = ""//String(game.spread)
            cell.visitingSpread.text = "(" + String(game.spread) + ")"
            cell.homeSpread.text = "(" + String(-1*game.spread) + ")"
        }
        
        
        return cell
        
        
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