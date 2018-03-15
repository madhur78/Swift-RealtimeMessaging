//
//  DataFormatter.swift
//  DriverMyDay
//
//  Created by Modugu, Surendar on 7/15/15.
//  Copyright © 2015 DPSG. All rights reserved.
//

import Foundation

class DataFormatter: NSObject {
    
    class func formatPrice(_ price: Double, scale: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let number:NSNumber = NSNumber(value: price)
        return formatter.string(from: number)!
    }
    
    class func formatPrice(_ price: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.number(from: price)!.doubleValue
    }
    
    class func formatPhoneNumber(_ phoneNumberStr: String) -> String {
        if phoneNumberStr.utf16.count < 10 {
            return phoneNumberStr
        }
        
        let stringts: NSMutableString = NSMutableString(string: phoneNumberStr)
        stringts.insert("(", at: 0)
        stringts.insert(")", at: 4)
        stringts.insert(" ", at: 5)
        stringts.insert("-", at: 9)
        return String(stringts)
    }
    
    class func formatZipcode(_ zipcodeStr: String) -> String {
        if zipcodeStr.utf16.count < 9 {
            return zipcodeStr
        }
        let stringts: NSMutableString = NSMutableString(string: zipcodeStr)
        stringts.insert("-", at: 5)
        return String(stringts)
    }
    
    class func formatDateFromString(_ date: String) -> Date! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd"
//        dateFormatter.dateFormat    = "dd MM hh:ss"
        return dateFormatter.date(from: date)
    }
    
    class func cleanPhoneNumber(_ phoneNumberStr: String) -> String {
        if phoneNumberStr.utf16.count < 14 {
            return phoneNumberStr
        }
        
        return phoneNumberStr.replacingOccurrences(of: "[^() ]", with: "", options: NSString.CompareOptions.regularExpression, range:nil);
    }
    
    class func cleanName(_ name: String) -> String {
        return name.replacingOccurrences(of: "[^a-zA-Z ,]", with: "", options: NSString.CompareOptions.regularExpression, range:nil);
    }
    
    class func getValidXMLString(_ xmlString: String) -> String {
        var resultString: String    = xmlString;
        resultString    = resultString.replacingOccurrences(of: "&", with: "&amp;")
        resultString    = resultString.replacingOccurrences(of: "<", with: "&lt;")
        resultString    = resultString.replacingOccurrences(of: ">", with: "&gt;")
        resultString    = resultString.replacingOccurrences(of: "'", with: "&apos;")
        resultString    = resultString.replacingOccurrences(of: "\"", with: "&quot;")
        return resultString;
    }
    
    class func getValidDateXMLString(_ xmlDate: Date) -> String {
        let dateFormmater: DateFormatter  = DateFormatter()
        dateFormmater.dateFormat    = "M/d/yyyy h:mm:ss a"
        return DataFormatter.getValidXMLString(dateFormmater.string(from: xmlDate))
    }
    
    class func checkNullString(_ stringObj : AnyObject!) -> String {
        if stringObj is String {
            let inputString:String = stringObj.trimmingCharacters(in: CharacterSet.whitespaces)
            if inputString.isEmpty || inputString.uppercased() == "NULL" {
                return ""
            } else {
                return inputString
            }
        } else {
            return ""
        }
    }
    
    class func checkNullInt(_ stringObj : AnyObject!) -> Int {
        if stringObj is String {
            let inputString:String = stringObj.trimmingCharacters(in: CharacterSet.whitespaces)
            if inputString.isEmpty || inputString.uppercased() == "NULL" {
                return 0
            } else {
                let result: Int! = Int(inputString)
                return result != nil ? result : 0
            }
        } else {
            return 0
        }
    }
    
    class func checkNullDouble(_ stringObj : AnyObject!) -> Double {
        if stringObj is String {
            let inputString:String = stringObj.trimmingCharacters(in: CharacterSet.whitespaces)
            if inputString.isEmpty || inputString.uppercased() == "NULL" {
                return 0
            } else {
                let result: Double! = Double(inputString)!
                return result != nil ? result : 0
            }
        } else {
            return 0
        }
    }
    
    class func trimSpace(_ str:String) ->String{
        return str.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    class func xmlSafeString(_ inputString:String) -> String {
        if inputString.trim().length == 0 {
            return ""
        }
        
        var invalidSet: NSMutableCharacterSet? = nil
        if invalidSet == nil {
            invalidSet =
                NSMutableCharacterSet(range: NSMakeRange(0x9, 1))
            invalidSet!.addCharacters(in: NSMakeRange(0xA, 1))
            invalidSet!.addCharacters(in: NSMakeRange(0xD, 1))
            invalidSet!.addCharacters(in: NSMakeRange(0x20, 0xD7FF - 0x20 + 1))
            invalidSet!.addCharacters(in: NSMakeRange(0xE000, 0xFFFD - 0xE000 + 1))
            invalidSet!.invert()
        }
        let tempArr = inputString.components(separatedBy: (invalidSet as? CharacterSet)!) as NSArray
        return tempArr.componentsJoined(by: " ")
    }
    
    
    class func FormatPrice(_ price:Double) -> String!{
        let formatter:NumberFormatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let number:NSNumber = NSNumber(value: price)
        return formatter.string(from: number)!
    }
    
    class func stringFromPrice(_ price: Double!) -> String {
        //print("stringFromPrice = \(price)")
        if price == nil {
            return String(format: "$%.2f", 0.0)
        }
        
        if price < 0 {
            return String(format: "$(%.2f)", -price)
        }else if price > 0{
            return String(format: "$%.2f", price)
        }else {
            return String(format: "$%.2f", 0.0)
        }
    }
    
    class func stringFromPriceWithoutDollar(_ price: Double!) -> String {
        if price == nil {
            return String(format: "%.2f", 0.0)
        }
        
        if price < 0 {
            return String(format: "(%.2f)", -price)
        }else if price > 0{
            return String(format: "%.2f", price)
        }else {
            return String(format: "%.2f", 0.0)
        }
    }
    
    class func stringFromDouble(_ price: Double) -> String {
        if price < 0 {
            return String(format: "(%.2f)", -price)
        }else if price > 0{
            return String(format: "%.2f", price)
        }else {
            return String(format: "%.2f", 0)
        }
    }
    
    class func intStringFromDouble(_ price: Double) -> String {
        return String(format: "%.0f", price)
    }
    
    class func formatDecimal(_ value: AnyObject, size: Int) -> String {
        if Int(value as! Double)  == 0 {
            return "0.0"
        }
        
        var s: String   = String(format: "%.\(size)f", value as! Double)
        while s.length > 0 && s.indexOf(".") != -1 && (s.charAtIndex(s.length-1) == "0" || s.charAtIndex(s.length-1) == ".") {
            s   = s.subString(0, length: s.length-1)
        }
        
        return s
    }
    
}
