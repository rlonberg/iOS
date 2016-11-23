//
//  FIFAmenuViewController.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 5/5/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

let fifaURLlink = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Soccer"
var fifaURL = URL(string: fifaURLlink)

var FIFAfilter = ["Eng. Premier", "Bundesliga", "Serie A", "La Liga", "USA (MLS)"]// ["Copa America", "UEFA EURO"] //, "MLS"] // COPA AMERICA ////["English Premier League", "Bundesliga", "Serie A", "La Liga", "MLS"]
var FIFAadjustLink = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Soccer"

class FIFAmenuViewController: UIViewController {
    
    @IBOutlet weak var EPL: UISwitch!
    @IBOutlet weak var Bundesliga: UISwitch!
    @IBOutlet weak var SerieA: UISwitch!
    @IBOutlet weak var LaLiga: UISwitch!
    @IBOutlet weak var MLS: UISwitch!
    @IBOutlet weak var UefaEuro: UISwitch!
    @IBOutlet weak var CopaAmerica: UISwitch!
    
    @IBAction func proceedToFIFA(_ sender: UIButton) {
        print("proceeding to fifa")
        var filter:[String] = []
        if EPL.isOn {
            filter.append("Eng. Premier")
        }
        if Bundesliga.isOn {
            filter.append("Bundesliga")
        }
        if SerieA.isOn {
            filter.append("Serie A")
        }
        if LaLiga.isOn {
            filter.append("La Liga")
        }
        if MLS.isOn {
            filter.append("USA (MLS)")
        }
        if CopaAmerica.isOn {
            filter.append("Copa America")
        }
        if UefaEuro.isOn {
            filter.append("UEFA EURO")
        }
        
        //print(filter)
        
        /*
        if filter.count == 1 {
            FIFAadjustLink.appendContentsOf("&sportsubtype=")
            FIFAadjustLink.appendContentsOf(filter[0])
            fifaURL = NSURL(string: FIFAadjustLink)
        }
        */
        
        FIFAfilter = filter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
