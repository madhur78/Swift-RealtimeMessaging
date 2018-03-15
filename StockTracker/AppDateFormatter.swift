//
//  DateFormatter.swift
//  DriverMyDay
//
//  Created by Modugu, Surendar on 8/5/15.
//  Copyright © 2015 DPSG. All rights reserved.
//

import Foundation

class AppDateFormatter: NSObject {
    static let DATEFORMAT_MMDDYY: String = "MM/dd/yy"
    static let DATEFORMAT_MMDDYYYY: String = "MM/dd/yyyy"
    static let DATEFORMAT_DB: String = "yyyy-MM-dd"
    static let DATEFORMAT_DEX: String = "yyyyMMdd"
    static let DATETIME_FORMAT_TZ_DB: String = "MM/dd/yyyy h:mm:ss ZZZ"
    static let DATETIME_FORMAT_DB: String = "MM/dd/yyyy h:mm:ss"
    
    // static let DATETIME_FORMAT_PUNCH: String = "MM/dd/yyyy hh:mm:ss a"
    static let DATETIME_FORMAT_ONSTREET: String = "MM/dd/yyyy h:mm:ss a"
    // static let DATEFORMAT_YYYYMMDDHHmmss: String = "yyyy-MM-dd HH:mm:ss.SSS"
    
    static let DATEFORMAT_EEEEMMMMDDYYYY = "EEEE, MMMM dd, yyyy"
    static let DATEFORMAT_EEEEMMMMDD = "EEEE, MMMM dd"
    static let DATEFORMAT_MMMDD = ", MMMM dd"
    static let DATEFORMAT_MMM_DD = "MMMM dd, yyyy"
    static let DATEFORMAT_MMDDD = "dd MMM"
    static let DATEFORMAT_EEE = "EEE"
    static let DATEFORMAT_HHMMA = "hh:mm a"
    
    static let DATETIME_FORMAT_LAST_PUNCH: String = "M/d/yyyy hh:mm a"
    
    static let DATETIME_FORMAT_TIMEPUNCH: String = "MM/dd/yyyy HH:mm:ss"
    static let DATEFORMAT_EEEEMMMMDDYYYYHHMM = "EEEE MMM dd, yyyy h:mm a"
    
    //    class func formatPricingDate(date: NSDate) -> String {
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = DATEFORMAT_YYYYMMDDHHmmss
    //        return dateFormatter.stringFromDate(date)
    //    }
    class func formatIriDateString(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func formatHistGridDate(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMDDD
        return dateFormatter.string(from: date)
    }
    
    class func getDayOfWeek(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_EEE
        return dateFormatter.string(from: date)
    }
    
    class func formatDeliveryDate(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_EEEEMMMMDD
        return dateFormatter.string(from: date)
    }
    
    class func formatDeliveryDateWithoutDOY(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMMDD
        return dateFormatter.string(from: date)
    }
    
    class func todayDatePdfFormat() -> String {
        let date = Date()
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMM_DD
        return dateFormatter.string(from: date)
    }
    
    class func formatXMLDate(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
    }
    
    class func formatDate(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMDDYY
        return dateFormatter.string(from: date)
    }
    
    class func formatDateForXML(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMDDYYYY
        return dateFormatter.string(from: date)
    }
    
    class func formatShortDateY4(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func formatDate(_ date: Date!, format: String) -> String {
        var mDate = date
        if mDate == nil {
            mDate = Date.distantPast
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: mDate!)
    }
    
    //    class func formatReportDateString(date: String!, format: String) -> String {
    //        var mDate = date
    //        if mDate == nil {
    //            mDate = dbStringFromDate(NSDate())
    //        }
    //
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = DATEFORMAT_DB
    //        var tempDate = dateFormatter.dateFromString(mDate)
    //
    //        if tempDate == nil {
    //            dateFormatter.dateFormat = DATETIME_FORMAT_DB
    //            tempDate = dateFormatter.dateFromString(mDate)
    //        }
    //
    //        if tempDate == nil {
    //            dateFormatter.dateFormat = DATETIME_FORMAT_TZ_DB
    //            tempDate = dateFormatter.dateFromString(mDate)
    //        }
    //
    //        if tempDate == nil {
    //            dateFormatter.dateFormat = DATETIME_FORMAT_ONSTREET
    //            tempDate = dateFormatter.dateFromString(mDate)
    //        }
    //        dateFormatter.dateFormat = format.stringByReplacingOccurrencesOfString("tt", withString: "a")
    //        if tempDate == nil {
    //            return ""
    //        }
    //        return dateFormatter.stringFromDate(tempDate!)
    //    }
    
    //    class func formatReportDate(date: NSDate!, format: String) -> String {
    //        var mDate = date
    //        if mDate == nil {
    //            mDate = NSDate()
    //        }
    //
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = format.stringByReplacingOccurrencesOfString("tt", withString: "a")
    //        return dateFormatter.stringFromDate(mDate!)
    //    }
    
    class func dateFromDBString(_ dateStr: String!) -> Date {
        if dateStr == nil || dateStr == "null" || dateStr == "" {
            return Date.distantPast
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_DB
        return dateFormatter.date(from: dateStr)!
    }
    
    class func todayDateDB() -> Date {
        return dateFromDBString(todayDBDateString())
    }
    
    //    class func dateFromLongDBString(dateStr: String!) -> NSDate {
    //        if dateStr == nil || dateStr == "null" || dateStr == "" {
    //            return NSDate.distantPast()
    //        }
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = DATEFORMAT_YYYYMMDDHHmmss
    //        return dateFormatter.dateFromString(dateStr)!
    //    }
    
    class func dbStringFromDate(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_DB
        return dateFormatter.string(from: date)
    }
    
    class func apDateString(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_MMDDYY
        return dateFormatter.string(from: date)
    }
    
    class func daysBetweenDate(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
        
        return components.day!
    }
    
    class func dateTimeFromDBString(_ dateStr: String!) -> Date {
        if dateStr == nil || dateStr == "null" {
            return Date.distantPast
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATETIME_FORMAT_TZ_DB
        var date: Date! = dateFormatter.date(from: dateStr)
        if date == nil {
            dateFormatter.dateFormat = DATETIME_FORMAT_DB
            date = dateFormatter.date(from: dateStr)
        }
        return date
    }
    
    class func dateTimeStringForDB(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATETIME_FORMAT_TZ_DB
        return dateFormatter.string(from: date)
    }
    
    //    class func dateTimeStringForOnStreetStatus(date: NSDate!) -> String {
    //        if date == nil {
    //            return ""
    //        }
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.dateFormat = DATETIME_FORMAT_ONSTREET
    //        return dateFormatter.stringFromDate(date)
    //    }
    //
    //    class func GMTdateTimeStringForOnStreetStatus(date: NSDate!) -> String {
    //        if date == nil {
    //            return ""
    //        }
    //        let dateFormatter = NSDateFormatter()
    //        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
    //        dateFormatter.dateFormat = DATETIME_FORMAT_ONSTREET
    //        return dateFormatter.stringFromDate(date)
    //    }
    
    class func dateFromModifiedString(_ dateStr: String) -> Date! {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        return dateFormatter.date(from: dateStr)!
    }
    
    class func dateTimeStringForOnStreetStatus(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATETIME_FORMAT_ONSTREET
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
    }
    
    class func GMTdateTimeStringForOnStreetStatus(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = DATETIME_FORMAT_ONSTREET
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: date)
    }
    
    class func convertToGMTDate(_ date: Date!) -> String {
        if date == nil {
            return ""
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'Z'"
        return dateFormatter.string(from: date)
    }
    
    class func todayString() -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATETIME_FORMAT_TZ_DB
        return dateFormatter.string(from: Date())
    }
    
    class func todayDBDateString() -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_DB
        return dateFormatter.string(from: Date())
    }
    
    class func todayString(_ format: String) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    class func todayFullDate() -> String {
        return formatHistoryDate(nil)
    }
    
    class func formatHistoryDate(_ date: Date!) -> String
    {
        var mDate = date
        if mDate == nil {
            mDate = Date()
        }
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_EEEEMMMMDDYYYY;
        return dateFormatter.string(from: mDate!)
    }
    
    class func dateFromDEXString(_ dateStr: String) -> Date {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_DEX
        return dateFormatter.date(from: dateStr)!
    }
    
    class func dexStringFromDate(_ date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_DEX
        return dateFormatter.string(from: date)
    }
    
    class func dateTimeFromDBString(_ dateStr: String!, convertFormat: String, format: String) -> String {
        if dateStr == nil {
            return ""
        }
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = convertFormat
        let tempDate = dateFormatter.date(from: dateStr)
        if tempDate == nil {
            return ""
        }
        
        let dateFormatter1 = Foundation.DateFormatter()
        dateFormatter1.dateFormat = format
        
        return dateFormatter1.string(from: tempDate!)
    }
    
    class func precisionFormat(_ date: Date) -> NSString {
        let x = Date().timeIntervalSince(date)
        let seconds = NSString(format: "%0.2f", x)
        return seconds
    }
    
    class func addDaystoDate(_ inputDate: Date, daystoAdd: Int) -> Date {
        let newDate = (Calendar.current as NSCalendar)
            .date(
                byAdding: .day,
                value: daystoAdd,
                to: inputDate,
                options: []
        )
        return newDate!
    }
    
    class func getTimeFromDate(_ date: Date!) -> String
    {
        var mDate = date
        if mDate == nil {
            mDate = Date()
        }
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_HHMMA;
        return dateFormatter.string(from: mDate!)
    }
    
    class func getTimePunchFromDBString(_ dateStr: String!) -> Date {
        if dateStr == nil || dateStr == "null" || dateStr == "" {
            return Date.distantPast
        }
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATETIME_FORMAT_TIMEPUNCH
        return dateFormatter.date(from: dateStr)!
    }
    
    class func todayStringForApp() -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = DATEFORMAT_EEEEMMMMDDYYYYHHMM
        return dateFormatter.string(from: Date())
    }
    
    class func dateTimeFromFirebaseDBString(_ dateStr: String!) -> Date {
        if dateStr == nil || dateStr == "null" {
            return Date.distantPast
        }
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        dateFormatter.dateFormat = DATEFORMAT_EEEEMMMMDDYYYYHHMM
        var date: Date! = dateFormatter.date(from: dateStr)
        if date == nil {
            dateFormatter.dateFormat = DATEFORMAT_EEEEMMMMDDYYYYHHMM
            date = dateFormatter.date(from: dateStr)
        }
        return date
    }
    
}
