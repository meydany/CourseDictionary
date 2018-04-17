//
//  RMPManager.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 4/16/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

class RMPManager {
    
    struct GTResponse {
        var grade: String? = nil
        var comments: [String] = []
        var success: Bool =  false
    }
    
    struct LinkResponse {
        var success: Bool = false
        var link: String = ""
    }
    
    
    class func getTeacherInfo(teacherName: String, completion: @escaping (GTResponse) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            getTeacherLink(name: teacherName) { (response) in
                if(response.success) {
                    Alamofire.request(response.link).response { (response) in
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let doc: Document = try! SwiftSoup.parse(utf8Text)
                            
                            let grade = self.getAverageGrade(doc: doc)
                            let comments = self.getComments(doc: doc)
                            DispatchQueue.main.async {
                                completion(GTResponse(grade: grade, comments: comments, success: true))
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(GTResponse())
            }
        }
    }
    
    private class func getTeacherLink(name: String, completion: @escaping (LinkResponse) -> Void) {
        let teacher = name.capitalized.replacingOccurrences(of: " ", with: "+")
        let link = "http://www.ratemyprofessors.com/search.jsp?queryoption=HEADER&queryBy=teacherName&schoolName=University+of+North+Carolina+at+Chapel+Hill&schoolID=&query=\(teacher)"
        
        Alamofire.request(link).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let doc: Document = try! SwiftSoup.parse(utf8Text)
                
                if let href = try!doc.body()?.getElementsByClass("listing PROFESSOR").first()?.getElementsByTag("a").attr("href") {
                    completion(LinkResponse(success: true, link: "http://www.ratemyprofessors.com\(href)"))
                }else {
                    completion(LinkResponse())
                }
            }
            
        }
    }
    
    private class func getAverageGrade(doc: Document) -> String? {
        if let grade = try! doc.body()?.getElementsByClass("grade").first()?.text() {
            return grade
        }else {
            return nil
        }
    }
    
    private class func getComments(doc: Document) -> [String] {
        var comments: [String] = []
        for comment in (try! doc.body()?.getElementsByClass("comments").array())! {
            if let commentString = try? comment.getElementsByClass("commentsParagraph").first()?.text() {
                comments.append(commentString!)
            }
        }
        return comments
    }
    
}
