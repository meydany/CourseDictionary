//
//  GTManager.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 4/16/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

class GTManager {
    
    struct GTResponse {
        var grades: [String]?
        var success: Bool = false
        static var FailedResponse: GTResponse {
            get {
                return GTResponse(grades: nil, success: false)
            }
        }
    }
    
    class func getCourseInfo(course: String, completion: @escaping (GTResponse) -> ()) {
        if(course.length != 7) {
            print("Wrong format")
        }
        let courseTitle = course[0..<4]
        let courseNum =  course[4..<7]
        
        DispatchQueue.global(qos: .userInteractive).async {
            getClassLink(courseTitle: courseTitle) { (response) in
                if let link = response {
                    getCourseLink(courseNum: courseNum, link: link, completion: { (response) in
                        print(response!)
                    })
                }
            }
        }
        
    }
    
    //Gets link for 3 number course identifier (233, 101, 401, etc)
    private class func getCourseLink(courseNum: String, link: String, completion: @escaping (String?) -> ()) {
        Alamofire.request(link).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let doc: Document = try! SwiftSoup.parse(utf8Text)
                let courseGroup = try! doc.body()?.getElementsByClass("margin-bottom-5")
                for course in (courseGroup?.array())! {
                    if(try! course.getElementsByTag("strong").text() == courseNum) {
                        let courseLink = try! course.getElementsByTag("a").attr("href")
                        completion("http://gradetoday.com\(courseLink)")
                    }
                }
            }
        }
    }
    
    //Gets link for 4 letter course identifier (MATH, CHEM, COMP, etc)
    private class func getClassLink(courseTitle: String, completion: @escaping (String?) -> (Void)) {
        let link = "http://gradetoday.com/departments/3"
        Alamofire.request(link).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let doc: Document = try! SwiftSoup.parse(utf8Text)
                let courseGroups = try! doc.body()?.getElementsByClass("col-xs-12 col-s-6 col-md-4 department-item-group")
                for group in courseGroups!.array() {
                    if(try! group.getElementsByClass("color-dark-blue department-item-group-header").first()?.text().first == courseTitle[0]) {
                        let classGroup = try! group.getElementsByClass("color-orange color-dark-blue-hover font-work-sans font-size-20 uppercase no-underline-hover")
                        for innerClass in classGroup {
                            if(try! innerClass.getElementsByTag("strong").text() == courseTitle.uppercased()) {
                                let classLink = try! innerClass.getElementsByTag("a").attr("href")
                                completion("http://gradetoday.com\(classLink)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private class func getGrades(link: String, completion: @escaping ([String]) -> ()) {
        var grades: [String] = []
        
        Alamofire.request(link).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let doc: Document = try! SwiftSoup.parse(utf8Text)
                let record = try! doc.getElementsByTag("script").get(7).data().components(separatedBy: "\n\n")[2]
                let indexes = record.ranges(of: "value")
                
                for index in indexes {
                    let lowerIndex = record.index(index.lowerBound, offsetBy: 9)
                    let upperIndex = record.index(lowerIndex, offsetBy: 4)
                    
                    grades.append(String(record[lowerIndex..<upperIndex]))
                }
                completion(grades)
                return
            }
        }
    }
    
}
