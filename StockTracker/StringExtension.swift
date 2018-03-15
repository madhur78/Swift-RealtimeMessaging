//
//  StringExtension.swift
//  DPSReports
//
//  Created by Modugu, Surendar on 8/13/15.
//  Copyright © 2015 DPSG. All rights reserved.
//

import Foundation

extension String
{
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func contains(_ s: String) -> Bool {
        return self.range(of: s) != nil
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    subscript (i: Int) -> Character
        {
        get {
            let index = self.characters.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound - 1)
            
            return self[(startIndex ..< endIndex)]
        }
    }
    
    func subString(_ startIndex: Int, length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: (start ..< end))
    }
    
    func charAtIndex(_ index: Int) -> Character! {
        let charIndex   = self.characters.index(self.startIndex, offsetBy: index)
        if charIndex < self.startIndex || charIndex > self.endIndex {
            return nil
        }
        return self[charIndex]
    }
    
    func indexOf(_ target: String) -> Int {
        if let range = self.range(of: target) {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    func indexOf(_ target: String, startIndex: Int) -> Int {
        let startRange = self.characters.index(self.startIndex, offsetBy: startIndex)
        let range = self.range(of: target, options: NSString.CompareOptions.literal, range: (startRange ..< self.endIndex))
        
        if let range = range {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(_ target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(_ regex: String, options: NSRegularExpression.Options) -> Bool
    {
        do {
            let exp = try NSRegularExpression(pattern: regex, options: options)
            
            let matchCount = exp.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.length))
            return matchCount > 0
        }
        catch let error as NSError {
            print(error.description)
        }
        return false
    }
    
    func getMatches(_ regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult]
    {
        do {
            let exp = try NSRegularExpression(pattern: regex, options: options)
            
            let matches = exp.matches(in: self, options: [], range: NSMakeRange(0, self.length))
            return matches as [NSTextCheckingResult]
        }
        catch let error as NSError {
            print(error.description)
        }
        return []
    }
    
    func matchesForRegexInText(_ regex: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    fileprivate var vowels: [String]
        {
        get
        {
            return ["a", "e", "i", "o", "u"]
        }
    }
    
    fileprivate var consonants: [String]
        {
        get
        {
            return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
        }
    }
    
    
    func boolValue() -> Bool{
        if self == "false" || self == "FALSE" {
            return false
        }else{
            return true
        }
    }
    
    func doubleValue() -> Double {
        return NSString(string: self).doubleValue
    }
    
    func roundValue() -> Double {
        return round(self.doubleValue())
    }
    
    func padLeft(_ length: Int, char: Character) -> String {
        var result:String   = self
        while result.length < length {
            result    = String(char) + result
        }
        return result
    }
    
    func padRight(_ length: Int, char: Character) -> String {
        var result:String   = self
        while result.length < length {
            result  += String(char)
        }
        return result
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func sliceFrom(_ start: String, to: String) -> String? {
        return (range(of: start)?.lowerBound).flatMap { sInd in
            (range(of: to, range: sInd..<endIndex)?.upperBound).map { eInd in
                substring(with: sInd..<eInd)
            }
        }
    }
    
    func split(_ delimiter:String?="", limit:Int=0) -> [String] {
        let arr = self.components(separatedBy: (delimiter != nil ? delimiter! : ""))
        return Array(arr[0..<(limit > 0 ? min(limit, arr.count) : arr.count)])
    }
    
    func URLEncodedString() -> String? {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString
    }
}

extension Character {
    func utf8Value() -> UInt8 {
        for s in String(self).utf8 {
            return s
        }
        return 0
    }
    
    func utf16Value() -> UInt16 {
        for s in String(self).utf16 {
            return s
        }
        return 0
    }
    
    func unicodeValue() -> UInt32 {
        for s in String(self).unicodeScalars {
            return s.value
        }
        return 0
    }
}

extension UIFont {
    func sizeOfString (_ string: NSString, constrainedToWidth width: CGFloat) -> CGSize {
        return string.boundingRect(with: CGSize(width: width, height: CGFloat.infinity),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSFontAttributeName: self],
                                   context: nil).size
    }
}

extension NSString
{
    func charAtIndex(_ index: Int) -> Character! {
        if index < 0 || index >= self.length {
            return nil
        }
        
        let char: unichar   = self.character(at: index)
        return Character(UnicodeScalar(char)!)
    }
}



struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

extension UISearchBar {
    func changeCursorTintColor(_ color: UIColor) {
        for subView in self.subviews[0].subviews {
            if subView is UITextField{
                subView.tintColor = color
            }
        }
    }
}

extension UIImage {
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        
        //        let radiansToDegrees: (CGFloat) -> CGFloat = {
        //            return $0 * (180.0 / CGFloat(M_PI))
        //        }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0,y:0), size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip) {
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        // CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
}

extension NSString {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "Error Occurred")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}


