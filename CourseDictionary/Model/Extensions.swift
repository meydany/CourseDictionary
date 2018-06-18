//
//  Extensions.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 4/16/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let CarolinaBlue = UIColor(red: 153/255, green: 186/255, blue: 221/255, alpha: 1)
    static let DarkBlue = UIColor(red: 34/255, green: 53/255, blue: 94/255, alpha: 1)
    static let ThemeGreen = UIColor(red: 46/255, green: 213/255, blue: 115/255, alpha: 1)
    static let ThemeYellow = UIColor(red: 236/255, green: 204/255, blue: 104/255, alpha: 1)
    static let ThemeRed = UIColor(red: 255/255, green: 71/255, blue: 87/255, alpha: 1)
}


extension StringProtocol where Index == String.Index {
    func index<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound  ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

}

extension String {
    var length: Int {
        get {
            return self.count
        }
    }
    
    func contains(s: String) -> Bool {
        return self.range(of: s) != nil ? true : false
    }
    
    
    subscript (i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String
    {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound-1)
            
            return String(self[startIndex...endIndex])
        }
    }
    
    
    func indexOf(target: String) -> Int
    {
        var range = self.range(of: target)
        if let range = range {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        var startRange = self.index(self.startIndex, offsetBy: startIndex)
        
        var range = self.range(of: target, options: String.CompareOptions.literal, range: startRange..<self.endIndex)
        if let range = range {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
}
