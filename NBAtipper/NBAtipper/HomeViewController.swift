//
//  HomeViewController.swift
//  NBAtipper
//
//  Created by Ravi Lonberg on 5/8/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

var bill:Float = 0.0

class HomeViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    
    @IBAction func calculateAction(sender: UIButton) {
        if Float(billField.text!) == nil {
            let alertController = UIAlertController(title: "Can't tip that!", message:
                "Enter a correct bill amount", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            bill = Float(billField.text!)!
        }
    }
    
    override func viewDidLoad() {
        billField.keyboardType = UIKeyboardType.DecimalPad//.NumbersAndPunctuation
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
