//
//  SearchViewController.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 6/14/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var savedTableView: UITableView!
    
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var heartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Quickly adjust tint of search icon to match theme

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.DarkBlue]
        
        let tintedSearchImage = #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)
        searchIcon.image = tintedSearchImage
        searchIcon.tintColor = UIColor.CarolinaBlue
        
        let tintedHeartImage = #imageLiteral(resourceName: "heart-outline").withRenderingMode(.alwaysTemplate)
        heartIcon.image = tintedHeartImage
        heartIcon.tintColor = UIColor.DarkBlue
        heartLabel.textColor = UIColor.DarkBlue
        
        savedTableView.delegate = self
        savedTableView.dataSource = self
    }
    
    //-----------------------------TABLE VIEW-----------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open course logic
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of saved courses logic
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell") as! SavedCellView
        //customize cell logic goes here
        
        return cell
    }
    
    //--------------------------------------------------------------------//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
