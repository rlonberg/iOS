//
//  NBAdownloader.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/20/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import Foundation

let nbaURLlink = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Basketball&sportsubtype=NBA"
let nbaURL = URL(string: nbaURLlink)


///
/// Downloads league information from PinnacleSports server and parses the XML feed
///  populates companion TableViewController
///
class NBAdownloader: NSObject, XMLParserDelegate {
    
    // Game struct for a typical NBA (basketball) event
    struct Game {
        var datetime = ""
        var league = ""
        var isLive:Bool
        var away = ""
        var home = ""
        var spread = 0.0
        
    }
    
    
    
    // specify an NSXMLparser to handle XML feed from pinnacle sports (nbaURL)
    var parser: XMLParser!
    
    // eg: ["2016-04-14 00:05", "NBA", "No", "Sacramento Kings", "Visiting", "Houston Rockets", "Home", "15.5"]
    var strXMLData:[String] = []
    
    // ^ collection of all strXMLDatas on the night
    var rawSlate: [[String]] = []
    
    // parser toolset
    // currentElement: holds the current element that is being processed by parser
    // passData: should the processor ignore or read this field
    var currentElement:String = ""
    var passData:Bool=false
    
    
    // checks game segment field
    var gamePeriod:Bool=false
    
    // keeps track of which segment of the game we are on
    var whichPeriod = ""
    
    // arrived at a moneyline
    var foundMoneyLine:Bool=false
    
    
    
    ///
    /// Parses from PinnacleSports XML feed and builds the slate of NBA games
    ///     to be used by NBATableViewController. Should be the only method
    ///     called in NBAdownloader.
    ///
    /// - returns: NBA event slate, to populate NBA table view controller
    ///
    func returnSlate() -> [Game] {
        
        var slate:[Game] = []
        
        parser = XMLParser(contentsOf: nbaURL!)
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            slate = fillSlate(rawSlate)
            
            
        } else {
            print("parse failure!")
        }
        
        slate.sort { $0 < $1 }
        
        return slate
        
    }
    
    ///
    /// Builds preliminary NBA slate from raw feed scraped by XMLparser
    ///  eg: ["2016-04-14 00:05", "NBA", "No", "Sacramento Kings", "Visiting", "Houston Rockets", "Home", "15.5"]
    ///
    /// - parameter: rawFeed of initially parsed data from NSXMLparser
    ///
    /// - returns: preliminary slate of events for NBA (still needs to be sorted)
    ///
    fileprivate func fillSlate(_ rawFeed: [[String]]) -> [Game] {
        
        var finish:[Game] = []
        
        var datetime = ""
        var league = ""
        var isLive:Bool
        var away = ""
        var home = ""
        var spread = 0.0
        
        
        for index in rawFeed {
            
            datetime = index[0]
            datetime = GMTtoEST(datetime)
            
            league = index[1]
            
            if index[2]=="No" {
                isLive = false
            } else {
                isLive = true
            }
            
            away = index[3]
            home = index[5]
            
            if Double(index[7]) != nil {
                spread = Double(index[7])!
            } else {
                spread = -99.9
            }
            
            finish.append(Game(datetime: datetime, league: league, isLive: isLive, away: away, home: home, spread: spread))
            
        }
        
        return finish
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters a start tag for a given element.
    ///
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="participant_name" || elementName=="visiting_home_draw")
        {
            passData=true;
        }
        
        if(elementName=="period_description") {
            gamePeriod=true
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=true
        }
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters an end tag for a specific element.
    ///
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="participant_name" || elementName=="visiting_home_draw")
        {
            passData=false;
        }
        
        if(elementName=="period_description") {
            gamePeriod=false
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=false
        }
        
    }
    
    ///
    /// Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
    ///
    func parser(_ parser: XMLParser, foundCharacters string: String) {
     
        if gamePeriod {
            whichPeriod = string
        }
        
        ///
        /// foundMoneyLine relies on the gamePeriod string (above)
        ///  .. indicates arrival at the visiting spread for the full Game
        ///
        if foundMoneyLine {
            if whichPeriod=="Game" {
                strXMLData.append(string)
                
                ///
                /// extra overhead to tie off a filled event and then start a new one
                /// this is the last piece of information we need about a game before we can move to a new one.
                ///
                rawSlate.append(strXMLData)
                strXMLData.removeAll()
            }
        }
        
        ///
        /// passData boolean indicates that we are mid-Event.
        /// i.e. filling generic info fields such as:
        /// date, teams, is it live?
        ///
        if(passData)
        {
            strXMLData.append(string)
            
        }
        
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters a fatal error.
    ///
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        NSLog("failure error: %@", parseError as NSError)
    }
    
    
}



///
/// Overloads the less than operator so we can compare NBA games.
/// - parameter left: left operand
/// - parameter right: right operand
/// - returns: true if left < right, false otherwise
///
func <(left: NBAdownloader.Game, right: NBAdownloader.Game) -> Bool {
    
    
    let leftDays = daysThroughTheYear[monthAsInt(left.datetime)-1] + dayAsInt(left.datetime)
    let rightDays = daysThroughTheYear[monthAsInt(right.datetime)-1] + dayAsInt(right.datetime)
    
    if leftDays == rightDays {
        let leftHour = (hourAsInt(left.datetime)*60) + minuteAsInt(left.datetime)
        let rightHour = (hourAsInt(right.datetime)*60) + minuteAsInt(right.datetime)
        
        if leftHour == rightHour {
            return false
        }
        
        return leftHour < rightHour
    } else {
        return leftDays < rightDays
    }
    
}



