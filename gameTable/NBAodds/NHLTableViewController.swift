//
//  NHLTableViewController.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/20/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit


///
/// Populates table with event information pulled from companion downloader
///
class NHLTableViewController: UITableViewController {
    
    var slate:[NHLdownloader.Game] = [] {
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
        refreshControl!.addTarget(self, action: #selector(NHLTableViewController.refreshNHLslate), forControlEvents: UIControlEvents.ValueChanged)
        
        refreshNHLslate()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func refreshNHLslate() {
        let refreshOperation = NSBlockOperation(block: {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let downloader = NHLdownloader()
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
        
        let cellIdentifier = "NhlCell"
        
        let game = slate[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NHLTableViewCell
        
        cell.date.text = game.datetime.componentsSeparatedByString("+")[0]
        cell.spread.text = ""//"visiting spread set at " + String(game.spread)
        cell.awaySpread.text = "(" + String(game.spread) + ")"
        cell.homeSpread.text = "(" + String(-1*game.spread) + ")"
        
        cell.awayTeam.text = game.away
        cell.homeTeam.text = "at " + game.home
        cell.awayImage.image = UIImage(named: game.away)
        cell.homeImage.image = UIImage(named: game.home)
        
        //check if we have reached spread for total goals on the day
        if game.away.rangeOfString("Goals") != nil {
            cell.date.text = "NHL Total Goals Spread"
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