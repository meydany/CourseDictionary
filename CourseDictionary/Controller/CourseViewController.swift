//
//  CourseViewController.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 6/15/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import UIKit
import Segmentio

class CourseViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var reviewsContainerView: UIView!
    @IBOutlet weak var questionsContainerView: UIView!
    
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var classNumberLabel: UILabel!
    @IBOutlet weak var classRatingLabel: UILabel!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopView()
        //creates and customizes segmented control
        setupSegmentedControl()
                
    }
    
    private func setupTopView() {
        topView.layer.borderWidth = 0.2
        topView.layer.borderColor = UIColor.lightGray.cgColor
        
        classTitleLabel.textColor = UIColor.DarkBlue
        classNumberLabel.textColor = UIColor.DarkBlue
        classRatingLabel.textColor = UIColor.ThemeGreen
        recommendationLabel.textColor = UIColor.DarkBlue
        creditLabel.textColor = UIColor.DarkBlue
    }
    
    private func setupSegmentedControl() {
        let segmentioViewRect = CGRect(x: 0, y: topView.frame.origin.y + topView.frame.height, width: UIScreen.main.bounds.width, height: 40)
        let segmentioView = Segmentio(frame: segmentioViewRect)
        segmentioView.selectedSegmentioIndex = 0
        
        var content = [SegmentioItem]()
        
        let reviewsTab = SegmentioItem(title: "Reviews", image: nil)
        let questionsTab = SegmentioItem(title: "Questions", image: nil)
        content.append(reviewsTab)
        content.append(questionsTab)
        
        let segmentioStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "HelveticaNeue-Light", size: 16)!,
                titleTextColor: .DarkBlue
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "HelveticaNeue-Light", size: 16)!,
                titleTextColor: .DarkBlue
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont(name: "HelveticaNeue-Light", size: 16)!,
                titleTextColor: .DarkBlue
            )
        )
        
        let segmentioOptions = SegmentioOptions(
            backgroundColor: UIColor.clear,
            segmentPosition: SegmentioPosition.fixed(
                maxVisibleItems: 2),
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions.init(
                type: SegmentioIndicatorType.bottom,
                ratio: 1,
                height: 5,
                color: UIColor.DarkBlue),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions.init(
                type: SegmentioHorizontalSeparatorType.none,
                height: 0,
                color: UIColor.clear),
            verticalSeparatorOptions: SegmentioVerticalSeparatorOptions.init(
                ratio: 0,
                color: UIColor.clear),
            imageContentMode: UIViewContentMode.center,
            labelTextAlignment: NSTextAlignment.center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates,
            animationDuration: 0.08
        )
        
        segmentioView.setup(
            content: content,
            style: SegmentioStyle.onlyLabel,
            options: segmentioOptions
        )
        
        segmentioView.valueDidChange = { (segmentio: Segmentio?, index: Int) in
            self.alternateViews(index: index)
        }
        
        view.addSubview(segmentioView)
    }
    
    private func alternateViews(index: Int) {
        switch(index) {
            case 0:
                reviewsContainerView.alpha = 1
                questionsContainerView.alpha = 0
            case 1:
                reviewsContainerView.alpha = 0
                questionsContainerView.alpha = 1
            default:
                reviewsContainerView.alpha = 1
                questionsContainerView.alpha = 0
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
