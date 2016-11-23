//
//  DateHandler.swift
//  NBAodds
//
//  Created by Ravi Lonberg on 5/5/16.
//  Copyright © 2016 Ravi Lonberg. All rights reserved.
//

import Foundation

let hoursDifferenceFromGMT = NSTimeZone.local.secondsFromGMT() / 60 / 60

extension Date {
    func dayOfWeek() -> Int? {
        if
            let cal: Calendar = Calendar.current,
            let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self) {
            return comp.weekday
        } else {
            return nil
        }
    }
}
/* (swift 2.x)
extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = String.CharacterView.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
*/
extension String { // Swift 3!
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex))
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex))
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
func hourAsInt(_ date: String) -> Int {
    var form = date.components(separatedBy: ",")[1]
    form = form.trimmingCharacters(in: CharacterSet.whitespaces)
    form = form.components(separatedBy: ":")[0]
    form = form.components(separatedBy: " ")[1]
    
    return Int(form)!
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by minute of the hour
///
/// - parameter: formatted datetime
///
/// - returns: minute (% 60) of datetime
///
func minuteAsInt(_ date: String) -> Int {
    var form = date.components(separatedBy: ",")[1]
    form = form.trimmingCharacters(in: CharacterSet.whitespaces)
    form = form.components(separatedBy: ":")[1][0...1]
    
    return Int(form)!
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by day of the month
///
/// - parameter: formatted datetime
///
/// - returns: day of datetime
///
func dayAsInt(_ date: String) -> Int {
    
    let form = date.components(separatedBy: "+")[1]
    let day = form.components(separatedBy: "-")[1]
    
    
    return Int(day)!
    
}

///
/// Measures an already formatted (one that has been passed through DateHandler.GMTtoEST) by month of the year
///
/// - parameter: formatted datetime
///
/// - returns: month of datetime
///
func monthAsInt(_ date: String) -> Int {
    
    let form = date.components(separatedBy: "+")[1]
    var month = form.components(separatedBy: "-")[0]
    month = month.trimmingCharacters(in: CharacterSet.whitespaces)
    
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
func GMTtoEST(_ gmt: String) -> String {
    
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
func ESThourAndMinute(_ gmt: String) -> String {
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
func ESTmorningOrAfternoon(_ gmt: String) -> String {
    let morningMax = 11 //11am or lower indicates a morning time
    if ((Int(gmt[11...12])! + 24)+hoursDifferenceFromGMT) % 24 > morningMax {
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
func eventDay(_ gmt: String) -> Int {
    //gmt
    var eventDay = Int(gmt[8...9])
    let eventHourAsGMT = Int(gmt[11...12])!
    let eventHourAsEST = eventHourAsGMT + hoursDifferenceFromGMT
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
func eventMonth(_ gmt: String) -> Int {
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
func ESTday(_ gmt: String) -> String {
    let nsDateObject = Date()
    let today = Int(nsDateObject.description[8...9])
    let dayOfEvent = eventDay(gmt)
    let monthOfEvent = eventMonth(gmt)
    
    if today == dayOfEvent {
        return "Today, at "
    } else {
        let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let monthDays = [31,29,31,30,31,30,31,31,30,31,30,30]
        
        var daysAhead = dayOfEvent - today!
        print(daysAhead)
        print(gmt)
        print(monthOfEvent)
        print(today)
        print(dayOfEvent)
        if daysAhead < 0 { // event is next month
            daysAhead = (monthDays[monthOfEvent-1] + dayOfEvent) - today!
        }
        
        return weekDays[ (daysAhead + (nsDateObject.dayOfWeek()!-1)) % weekDays.count ] + ", at "
    }
    
}

