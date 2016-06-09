//
//  MLBdownloader.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/19/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import Foundation

let mlbURLlink = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Baseball&sportsubtype=mlb"
let mlbURL = NSURL(string: mlbURLlink)



///
/// Downloads league information from PinnacleSports server and parses the XML feed
///  populates companion TableViewController
///
class MLBdownloader: NSObject, NSXMLParserDelegate {
    
    // Game struct for a typical MLB (baseball) event
    struct Game {
        var datetime = ""
        var league = ""
        var isLive:Bool
        var away = ""
        var awayPitcher = ""
        var home = ""
        var homePitcher = ""
        var spread = 0.0
        
    }
    
    // specify an NSXMLparser to handle XML feed from pinnacle sports (mlbURL)
    var parser: NSXMLParser!
    
    // eg: eg: ["2016-04-14 00:05", "MLB", "No", "San Francisco Giants", "Visiting", "M. CAIN", "Colorado Rockies", "Home", "J. DE LA ROSA", "-1.5"]
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
    
    // no line set?
    var noLine:Bool = false
    
    // converted, object-oriented version of rawSlate
    var slate:[Game] = []
    
    
    ///
    /// Parses from PinnacleSports XML feed and builds the slate of MLB games
    ///     to be used by MLBTableViewController. Should be the only method
    ///     called in MLBdownloader.
    ///
    /// - returns: MLB event slate, to populate MLB table view controller
    ///
    func returnSlate() -> [Game] {
        
        var slate:[Game] = []
        
        parser = NSXMLParser(contentsOfURL: mlbURL!)
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            slate = sortSlate(fillSlate(rawSlate))
            
            
        } else {
            print("parse failure!")
        }

        return slate
        
    }
    
    
    ///
    /// Sorts slate according datetime
    ///
    /// - parameter: unsorted event slate
    ///
    /// - returns: sorted event slate
    ///
    private func sortSlate(slate: [Game]) -> [Game] {
        
        var todaySlate:[Game] = []
        var futureSlate:[Game] = []
        
        for game in slate {
            if game.datetime.rangeOfString("Today") == nil {
                futureSlate.append(game)
            } else {
                todaySlate.append(game)
            }
        }
        
        todaySlate.sortInPlace  { $0 < $1 }
        futureSlate.sortInPlace { $0 < $1 }
        
        todaySlate += futureSlate
        
        return todaySlate
        
    }
    
    
    ///
    /// Builds preliminary MLB slate from raw feed scraped by XMLparser
    ///  eg: ["2016-04-14 00:05", "MLB", "No", "San Francisco Giants", "Visiting", "M. CAIN", "Colorado Rockies", "Home", "J. DE LA ROSA", "-1.5"]
    ///
    /// - parameter: rawFeed of initially parsed data from NSXMLparser
    ///
    /// - returns: preliminary slate of events for MLB (still needs to be sorted)
    ///
    private func fillSlate(rawFeed: [[String]]) -> [Game] {
        
        var finish:[Game] = []
        
        var datetime = ""
        var league = ""
        var isLive:Bool
        var away = ""
        var awayPitcher = ""
        var home = ""
        var homePitcher = ""
        var spread = 0.0
        
        
        for index in rawFeed {
            
            if index[6] != "Home" {
                
                datetime = GMTtoEST(index[0])
                league = index[1]
                
                if index[2]=="No" {
                    isLive = false
                } else {
                    isLive = true
                }
                
                away = index[3]
                awayPitcher = index[5]
                home = index[6]
                homePitcher = index[8]
        
                if index.count > 9 {
                    spread = Double(index[9])!
                } else {
                    spread = Double(-999)
                }
                
                finish.append(Game(datetime: datetime, league: league, isLive: isLive, away: away, awayPitcher: awayPitcher, home: home, homePitcher: homePitcher, spread: spread))
                
            }
            
        }
        
        return finish
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters a start tag for a given element.
    ///
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="participant_name" || elementName=="visiting_home_draw" || elementName=="pitcher")
        {
            passData=true;
        }
        
        if(elementName=="period_description") {
            gamePeriod=true
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=true
        }
        
        if (elementName=="periods") {
            noLine=true
        }
        
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters an end tag for a specific element.
    ///
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="participant_name" || elementName=="visiting_home_draw" || elementName=="pitcher")
        {
            passData=false;
        }
        
        if(elementName=="period_description") {
            gamePeriod=false
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=false
        }
        
        if (elementName=="periods") {
            noLine=false
        }
        
    }
    
    ///
    /// Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
    ///
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        
        if noLine {
            if string.isEmpty { // a line has not been set
                rawSlate.append(strXMLData)
                strXMLData.removeAll()
            }
        }
        
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
        
        
        
        /// bypass to check that we are not on a new event
        if strXMLData.count > 0 && (noLine==false) {
            
            ///
            /// to confirm that we haven't accidentally moved to the next event,
            ///  we check if we have arrived at a new datetime (signals a new event)
            ///  2 checks:
            ///    1) lengths equal?
            ///    2) same decade? 201 = 201
            ///
            
            if (string.characters.count == strXMLData[0].characters.count) && (string[0...2] == strXMLData[0][0...2]) {
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
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    
    
}




///
/// Overloads the less than operator so we can compare MLB games.
/// - parameter left: left operand
/// - parameter right: right operand
/// - returns: true if left < right, false otherwise
///
func <(left: MLBdownloader.Game, right: MLBdownloader.Game) -> Bool {
    
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
















































