//
//  FIFAdownloader.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 4/25/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

/*
 COPA AMERICA VERSION
 */

import Foundation

let majorLeagues:[String] = ["Eng. Premier", "Bundesliga", "Serie A", "La Liga", "USA (MLS)"]


///
/// Downloads league information from PinnacleSports server and parses the XML feed
///  populates companion TableViewController
///
/// FIFAdownloader is unique in that it pulls far more information than other downloader (from 4 UEFA leagues)
///
class FIFAdownloader: NSObject, XMLParserDelegate {
    
    // Game struct for a typical FIFA (soccer) event
    struct Game {
        var datetime = ""
        var league = ""
        var isLive:Bool
        var away = ""
        var home = ""
        var spread = 0.0
        
    }
    
    // specify an NSXMLparser to handle XML feed from pinnacle sports (fifaURL)
    var parser: XMLParser!
    
    // eg: ["2016-04-14 00:05", "NBA", "No", "Sacramento Kings", "Visiting", "Houston Rockets", "Home", "15.5"]
    var strXMLData:[String] = []
    
    // ^ collection of all strXMLDatas on the night
    var rawSlate: [[String]] = []
    
    // holds the current element that is being processed by parser
    var currentElement:String = ""
    
    // should the processor ignore or read this field
    var passData:Bool=false
    
    // checks game segment field, we only want to record vegas spreads on the entire event (not first half or quarter)
    var gamePeriod:Bool=false
    
    // keeps track of which segment of the game we are on
    var whichPeriod = ""
    
    // arrived at a moneyline
    var foundMoneyLine:Bool=false
    
    // look for soccer only (FIFA downloader is unique in that it scrapes from an XML feed that contains other sports as well)
    var checkSoccer:Bool = false
    var isSoccer:Bool = true
    
    // no line set?
    var noLine:Bool = false
    
    
    ///
    /// Parses from PinnacleSports XML feed and builds the slate of FIFA games
    ///     to be used by FIFATableViewController. Should be the only method
    ///     called in FIFAdownloader.
    ///
    /// - returns: FIFA event slate, to populate FIFA table view controller
    ///
    func returnSlate() -> [[Game]] {
        
        var slate:[Game] = []
        
        if fifaURL == nil {
            fifaURL = URL(string: FIFAadjustLink)
        }
        parser = XMLParser(contentsOf: fifaURL! as URL)
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            slate = fillSlate(rawSlate)
            
            
        } else {
            print("parse failure!")
        }
        
        let sortedSlate = sortSlate(slate)
        
        fifaURL = URL(string: fifaURLlink)
        
        return sortedSlate
        
    }
    
    ///
    /// Parses from PinnacleSports XML feed and builds the slate of FIFA games
    ///     to be used by FIFATableViewController. Should be the only method
    ///     called in FIFAdownloader.
    ///
    /// - returns: FIFA event slate, to populate FIFA table view controller
    ///
    func lightningReturnSlate() -> [[Game]] {
        
        var slate:[Game] = []
        
        var blendLink:URL
        var adjustLnk = ""
        
        for lge in FIFAfilter {
            
        adjustLnk = FIFAadjustLink + "&sportsubtype=" + lge
            
        adjustLnk = adjustLnk.replacingOccurrences(of: " ", with: "%20")
            
        print(adjustLnk)
        
        //adjustLnk = "http://xml.pinnaclesports.com/pinnaclefeed.aspx?sporttype=Soccer&sportsubtype=Copa%20America"
        blendLink = URL(string: adjustLnk)!
    
        
        parser = XMLParser(contentsOf: blendLink)
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            slate = slate + fillSlate(rawSlate)
            rawSlate.removeAll()
            
            
        } else {
            print("parse failure!")
        }
            
        }
        
        let sortedSlate = sortSlate(slate)
        
        fifaURL = URL(string: fifaURLlink)
        
        return sortedSlate
        
    }
    
    ///
    /// Sorts preliminary event slate according to league name
    ///
    /// parameter: unsorted, preliminary event slate
    ///
    /// returns: FIFA event slate sorted by league name
    ///
    fileprivate func sortSlateByLeague(_ slate: [Game]) -> [[Game]] {
        var comprehensiveSlate:[[Game]] = []
        var leagues:[String] = []
        
        for game in slate {
            if leagues.index(of: game.league) == nil {
                leagues.append(game.league)
                comprehensiveSlate.append([])
            }
        }
        
        for game in slate {
            comprehensiveSlate[leagues.index(of: game.league)!].append(game)
        }
        
        var sortedSlate:[[Game]] = []
        for lg in FIFAfilter { // ["Eng. Premier", "Bundesliga", "Serie A", "La Liga", "USA (MLS)"] {
            if leagues.index(of: lg) != nil {
                sortedSlate.append(comprehensiveSlate[leagues.index(of: lg)!])
            } else {
                sortedSlate.append([])
            }
        }
        
        return sortedSlate
        
    }
    
    ///
    /// Sorts preliminary event slate according to league name
    ///
    /// parameter: unsorted, preliminary event slate
    ///
    /// returns: FIFA event slate sorted by league name
    ///
    fileprivate func sortSlateByDatetime(_ slate: [[Game]]) -> [[Game]] {
        
        var sort:[[Game]] = []
        var wedge:[Game] = []
        for league in slate {
            for game in league {
                wedge.append(game)
            }
            wedge.sort { $0 < $1 }
            sort.append(wedge)
            wedge.removeAll()
            
        }
        
        return sort
        
    }
    
    
    ///
    /// Sorts preliminary event slate according datetime
    ///
    /// - parameter: event slate that has already been sorted by league
    ///
    /// - returns: polished, sorted FIFA event slate to be sent to FIFATableViewController
    ///
    fileprivate func sortSlate(_ slate: [Game]) -> [[Game]] {
        
        let sortedByLeague:[[Game]] = sortSlateByLeague(slate)
        let sortedByLeagueAndDate:[[Game]] = sortSlateByDatetime(sortedByLeague)
        
        return sortedByLeagueAndDate
        
    }
    
    ///
    /// Builds preliminary FIFA slate from raw feed scraped by XMLparser
    ///  eg ["2016-04-30 13:30", "Bundesliga", "No", "Bayern Munchen", "Home", "Borussia Monchengladbach", "Visiting", "1.25"]
    /// - parameter: rawFeed of initially parsed data from NSXMLparser
    ///
    /// - returns: preliminary slate of events for FIFA (still needs to be sorted)
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
            
            if index.count > 7 {
                print(index)
                if (index[index.count-1]) != "Visiting" {
                    spread = Double(index[index.count-1])!
                } else {
                    spread = Double(-999)
                }
            } else {
                spread = Double(-999)
            }
            
            if away.range(of: "Teams") == nil && spread > -900 {
                finish.append(Game(datetime: datetime, league: league, isLive: isLive, away: away, home: home, spread: spread))
            }
            
        }
        
        return finish
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters a start tag for a given element.
    ///
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        
        if (elementName=="participant_name") {
            passData = true
        }
        
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="visiting_home_draw")
        {
            passData=true;
            
        }
        
        if(elementName=="period_description") {
            gamePeriod=true
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=true
        }
        
        if(elementName=="sporttype") {
            checkSoccer = true
        }
        
        if (elementName=="periods") {
            noLine=true
        }
        
    }
    
    ///
    /// Sent by a parser object to its delegate when it encounters an end tag for a specific element.
    ///
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        
        if (elementName=="participant_name") {
            passData=false
        }
        
        if(elementName=="event_datetimeGMT" || elementName=="league" || elementName=="IsLive" || elementName=="visiting_home_draw")
        {
            passData=false;
        }
        
        if(elementName=="period_description") {
            gamePeriod=false
        }
        
        if(elementName=="spread_visiting") {
            foundMoneyLine=false
        }
        
        
        if(elementName=="sporttype") {
            checkSoccer = false
        }
        
        if (elementName=="periods") {
            noLine=false
        }
        
        
    }
    
    ///
    /// Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
    ///
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if noLine {
            if string.isEmpty { // a line has not been set
                if FIFAfilter.index(of: strXMLData[1]) != nil {
                    rawSlate.append(strXMLData)
                }
                strXMLData.removeAll()
            }
        }
        
        if checkSoccer {
            if string == "Soccer" {
                isSoccer = true
            } else {
                isSoccer = false
            }
        }
        
        if isSoccer {
            
            
            if gamePeriod {
                whichPeriod = string
            }
            
            ///
            /// foundMoneyLine relies on the gamePeriod string (above)
            ///  .. indicates arrival at the visiting spread for the full Game
            ///
            if foundMoneyLine  {
                if whichPeriod=="Match" {
                    strXMLData.append(string)
                    if FIFAfilter.index(of: strXMLData[1]) != nil {
                        rawSlate.append(strXMLData)
                    }
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
                    if FIFAfilter.index(of: strXMLData[1]) != nil {
                        rawSlate.append(strXMLData)
                    }
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
                if string != "Draw" {
                    strXMLData.append(string)
                }
                
            }
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
/// Overloads the less than operator so we can compare FIFA games.
/// - parameter left: left operand
/// - parameter right: right operand
/// - returns: true if left < right, false otherwise
///
func <(left: FIFAdownloader.Game, right: FIFAdownloader.Game) -> Bool {
    
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
