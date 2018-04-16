//
//  ViewController.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 4/11/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup


struct LinkResponse {
    var success: Bool = false
    var link: String = ""
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

class ViewController: UIViewController {

    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GTManager.getTeacherInfo(teacherName: "jeannie loeb") { (response) in
            if(response.success) {
                print(response.grade!)
                print(response.comments)
            }
        }
        let link = "http://gradetoday.com/grades/4946/5120"
        
        Alamofire.request(link).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let doc: Document = try! SwiftSoup.parse(utf8Text)
                let record = try! doc.getElementsByTag("script").get(7).data().components(separatedBy: "\n\n")[2]
                let indexes = record.ranges(of: "value")
                
                var grades: [String] = []
                
                for index in indexes {
                    let lowerIndex = record.index(index.lowerBound, offsetBy: 9)
                    let upperIndex = record.index(lowerIndex, offsetBy: 4)
                    
                    grades.append(String(record[lowerIndex..<upperIndex]))
                }
                
            }
            
        }
        
//        getTeacherLink(name: "amy king") { (response) in
//            if(response.success) {
//                self.displayTeacherInfo(link: response.link)
//            }
//        }
        
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

