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
    
    class func getCourseInfo(course: String) {
        if(course.length != 7) {
            print("Wrong format")
        }
        let courseTitle = course[0..<4]
        let courseNum =  course[4..<7]
        
        DispatchQueue.global(qos: .userInteractive).async {
            getClassLink(courseTitle: course[0..<4]) { (response) in
                let link = response
                if(link != nil) {
                    Alamofire.request(link!).response { response in
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let doc: Document = try! SwiftSoup.parse(utf8Text)
                            let courseGroup = try! doc.body()?.getElementsByClass("margin-bottom-5")
                            for course in (courseGroup?.array())! {
                                if(try! course.getElementsByTag("strong").text() == courseNum) {
                                    print(try! course.getElementsByTag("a").attr("href"))
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    class func getClassLink(courseTitle: String, completion: @escaping (String?) -> Void) {
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
                                return
                            }
                        }
                    }
                }
            }
        }
        print("Course doesn't exist")
    }
    
    class func getGrades(link: String, completion: @escaping ([String]) -> Void) {
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

            }
        }
        completion(grades)
    }
    
}
