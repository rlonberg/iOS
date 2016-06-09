//
//  DateHandler.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 5/5/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import Foundation

let hoursDifferenceFromGMT = NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60

extension NSDate {
    func dayOfWeek() -> Int? {
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) {
            return comp.weekday
        } else {
            return nil
        }
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

// Shows the cumulative days through the year (by month), used for comparing dates
let daysThroughTheYear:[Int] = [31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 365]

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by hour of the day
///
/// - parameter: formatted datetime
///
/// - returns: hour of datetime
///
func hourAsInt(date: String) -> Int {
    var form = date.componentsSeparatedByString(",")[1]
    form = form.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    form = form.componentsSeparatedByString(":")[0]
    form = form.componentsSeparatedByString(" ")[1]
    
    return Int(form)!
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by minute of the hour
///
/// - parameter: formatted datetime
///
/// - returns: minute (% 60) of datetime
///
func minuteAsInt(date: String) -> Int {
    var form = date.componentsSeparatedByString(",")[1]
    form = form.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    form = form.componentsSeparatedByString(":")[1][0...1]
    
    return Int(form)!
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by day of the month
///
/// - parameter: formatted datetime
///
/// - returns: day of datetime
///
func dayAsInt(date: String) -> Int {
    
    let form = date.componentsSeparatedByString("+")[1]
    let day = form.componentsSeparatedByString("-")[1]
    
    
    return Int(day)!
    
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by month of the year
///
/// - parameter: formatted datetime
///
/// - returns: month of datetime
///
func monthAsInt(date: String) -> Int {
    
    let form = date.componentsSeparatedByString("+")[1]
    var month = form.componentsSeparatedByString("-")[0]
    month = month.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    
    return Int(month)!
    
}

///
/// Formats a datetime from XML-GMT format to a formatted EST time to be represented in the UI
///  input: "2016-04-19 02:35" -> output: "Today, at 10:35pm"
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: formatted datetime for UI (EST time)
///
func GMTtoEST(gmt: String) -> String {
    
    let timeOfEvent = ESThourAndMinute(gmt) + ESTmorningOrAfternoon(gmt)
    let dayOfEvent = ESTday(gmt)
    let dateOfEvent = " + " + String(eventMonth(gmt)) + "-" + String(eventDay(gmt))
    
    return dayOfEvent + timeOfEvent + dateOfEvent
}

///
/// Accepts an unformatted GMT time and returns the hour:minute by EST
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: hour:minute of datetime in EST
///
func ESThourAndMinute(gmt: String) -> String {
    let adjustHourByLocalTimeZone = (((Int(gmt[11...12])! + 24)+hoursDifferenceFromGMT)%24)%12
    let ESTtime = String(adjustHourByLocalTimeZone) + gmt[13...15]
    return ESTtime
}


///
/// Accepts an unformatted GMT time and returns "pm" or "am" 
///  depending on the time of day represented by the input
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: "pm" or "am"
///
func ESTmorningOrAfternoon(gmt: String) -> String {
    let morningMax = 11 //11am or lower indicates a morning time
    if ((Int(gmt[11...12])! + 24)-4) % 24 > morningMax {
        return "pm"
    } else {
        return "am"
    }
}


///
/// Accepts an unformatted GMT time and returns the day of the month 
///  represented by the input. Also checks if conversion to EST jumps back 1 day
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: day of the month
///
func eventDay(gmt: String) -> Int {
    gmt
    var eventDay = Int(gmt[8...9])
    let eventHourAsGMT = Int(gmt[11...12])!
    let eventHourAsEST = eventHourAsGMT - 4
    if eventHourAsEST < 0 {
        eventDay = eventDay! - 1
    }
    return eventDay!
}

///
/// Accepts an unformatted GMT time and returns the month number represented by the input
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: month of the year
///
func eventMonth(gmt: String) -> Int {
    let eventMonth = Int(gmt[5...6])
    return eventMonth!
}

///
/// Accepts an unformatted GMT time and returns the header ([Day of the Week], ...)
///  for that input as it will be presented in the table view
///  i.e."2016-04-19 02:35" -> "Tuesday, at..."
///
/// - parameter: unformatted datetime from XML parser (GMT time)
///
/// - returns: header for formatted datetime (EST)
///
func ESTday(gmt: String) -> String {
    let nsDateObject = NSDate()
    let today = Int(nsDateObject.description[8...9])
    let dayOfEvent = eventDay(gmt)
    let monthOfEvent = eventMonth(gmt)
    
    if today == dayOfEvent {
        return "Today, at "
    } else {
        let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let monthDays = [31,29,31,30,31,30,31,31,30,31,30,30]
        
        var daysAhead = dayOfEvent - today!
        
        if daysAhead < 0 { // event is next month
            daysAhead = (monthDays[monthOfEvent] + dayOfEvent) - today!
        }
        
        return weekDays[ (daysAhead + (nsDateObject.dayOfWeek()!-1)) % weekDays.count ] + ", at "
    }
    
}

