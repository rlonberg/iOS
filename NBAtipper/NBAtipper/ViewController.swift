//
//  ViewController.swift
//  NBAtipper
//
//  Created by Ravi Lonberg on 5/8/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var prevValue:Float = 20.0
    var prevName = "barbosa"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipValue: UILabel!

    @IBOutlet weak var tipSlider: UISlider!
    @IBAction func sliderChange(sender: UISlider) {
        tipValue.text = String(format: "%0.1f", generateTipPercentage(tipSlider.value)) + "% tip -> $" + String(format: "%0.2f", generateTipAmount(tipSlider.value)) + " total"
        if changeImage(tipSlider.value) != prevName {
            prevName = changeImage(tipSlider.value)
            imageView.image = UIImage(named: prevName)
        }
        /*
        if abs(tipSlider.value - prevValue) > 6.0 {
            prevValue = tipSlider.value
            imageView.image = UIImage(named: changeImage(tipSlider.value))
        }
        */
    }
    override func viewDidLoad() {
        tipValue.text = String(format: "%0.1f", generateTipPercentage(tipSlider.value)) + "% tip -> $" + String(format: "%0.2f", generateTipAmount(tipSlider.value)) + " total"
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateTipPercentage(value:Float) -> Float {
        let tipPercentage = 0.3 * value
        
        return tipPercentage
        
    }
    
    func generateTipAmount(value: Float) -> Float {
        return bill + (bill*(generateTipPercentage(value)/100))
    }
    
    
    func changeImage(value: Float) -> String {
        if value < 6 {
            return "looney"
        } else if (value > 6 && value < 12) {
            return "mcadoo"
        } else if (value > 12 && value < 18) {
            return "clark"
        } else if (value > 18 && value < 24) {
            return "barbosa"
        } else if (value > 24 && value < 30) {
            return "speights"
        } else if (value > 30 && value < 36) {
            return "rush"
        } else if (value > 36 && value < 42) {
            return "ezeli"
        } else if (value > 42 && value < 48) {
            return "barnes"
        } else if (value > 48 && value < 54) {
            return "bogut"
        } else if (value > 54 && value < 60) {
            return "shaun"
        } else if (value > 60 && value < 68) {
            return "andre"
        } else if (value > 68 && value < 77) {
            return "klay"
        } else if (value > 77 && value < 86) {
            return "draymond"
        } else if (value > 86 && value < 95) {
            return "kerr"
        } else if (value > 95) {
            return "curry"
        } else {
            return ""
        }
        
    }

    /*
 
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
 let options = ["russelPNG","durantPNG"]
 return options[Int(arc4random_uniform(6) + 1)%2]
 
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
 
 
 default:
 return ""
 }
 }
*/

}

