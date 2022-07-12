//
//  DatabaseViewController.swift
//  Hancock
//
//  Created by Jon Kido on 7/11/22.
//  Copyright © 2022 Jon Kido. All rights reserved.
//

import UIKit
import Charts
import Foundation

//MARK: Database View Controller
class DatabaseViewController: UIViewController , ChartViewDelegate {
    
    var mostRecent = "Title Screen"
    var actMastered = 0
    var averageTime = 0
    var averageAcc = 0
    var totalTime = 0
    var highestAcc = "No Data"
    var lowestAcc = "No Data"
    
    var uppercase = BarChartView()
    var lowercase = BarChartView()
    var chapter = BarChartView()
    var activityC = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // chart variables
        let lightgrey = UIColor(hexaString: "#C5C5C5")
        let white = UIColor(hexaString: "#FFFFFF")
        
        // scroll view
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        scrollView.contentSize=CGSize(width: view.frame.size.width, height: view.frame.size.height*2.5 + 90)
        scrollView.backgroundColor = UIColor(hexaString: "#E9ECEF")
        
        // views
        let overview = UIView(frame: CGRect(x: 15, y: 15, width: view.frame.size.width-30, height: view.frame.size.height/2))
        let recent = UIView(frame: CGRect(x: overview.frame.size.width*0/5, y: 0, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let mastered = UIView(frame: CGRect(x: overview.frame.size.width*1/5, y: 0, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let time = UIView(frame: CGRect(x: overview.frame.size.width*2/5, y: 0, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let activity = UIView(frame: CGRect(x: overview.frame.size.width*3/5, y: 0, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let totalTime = UIView(frame: CGRect(x: overview.frame.size.width*4/5, y: 0, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let highest = UIView(frame: CGRect(x: overview.frame.size.width*0/5, y: overview.frame.size.height/3, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let lowest = UIView(frame: CGRect(x: overview.frame.size.width*0/5, y: overview.frame.size.height*2/3, width: overview.frame.size.width/5, height: overview.frame.size.height/3))
        let overallAccuracy = UIView(frame: CGRect(x: overview.frame.size.width*1/5, y: overview.frame.size.height*1/3, width: overview.frame.size.width*4/5, height: overview.frame.size.height*2/3))
        let uppercaseAccuracy = UIView(frame: CGRect(x: 15, y: view.frame.size.height/2 + 30, width: view.frame.size.width-30, height: view.frame.size.height/2))
        let lowercaseAccuracy = UIView(frame: CGRect(x: 15, y: view.frame.size.height + 45, width: view.frame.size.width-30, height: view.frame.size.height/2))
        let chapterAccuracy = UIView(frame: CGRect(x: 15, y: view.frame.size.height*1.5 + 60, width: view.frame.size.width-30, height: view.frame.size.height/2))
        let activityPoints = UIView(frame: CGRect(x: 15, y: view.frame.size.height*2 + 75, width: view.frame.size.width-30, height: view.frame.size.height/2))
        uppercase.frame = CGRect(x: 15, y: uppercaseAccuracy.frame.size.height/6+15, width: uppercaseAccuracy.frame.size.width - 30, height: uppercaseAccuracy.frame.size.height*5/6-30)
        lowercase.frame = CGRect(x: 15, y: lowercaseAccuracy.frame.size.height/6+15, width: lowercaseAccuracy.frame.size.width - 30, height: lowercaseAccuracy.frame.size.height*5/6-30)
        chapter.frame = CGRect(x: 15, y: chapterAccuracy.frame.size.height/6+15, width: chapterAccuracy.frame.size.width - 30, height: chapterAccuracy.frame.size.height*5/6-30)
        activityC.frame = CGRect(x: 15, y: activityPoints.frame.size.height/6+15, width: activityPoints.frame.size.width - 30, height: activityPoints.frame.size.height*5/6-30)
        
        // colors
        time.backgroundColor =  lightgrey
        recent.backgroundColor = lightgrey
        mastered.backgroundColor = white
        activity.backgroundColor = white
        totalTime.backgroundColor =  lightgrey
        highest.backgroundColor = white
        lowest.backgroundColor = lightgrey
        overallAccuracy.backgroundColor = white
        uppercaseAccuracy.backgroundColor = white
        lowercaseAccuracy.backgroundColor = white
        chapterAccuracy.backgroundColor = white
        activityPoints.backgroundColor = white
        
        // dummy data
        let set = BarChartDataSet(entries: [
            BarChartDataEntry(x: 1, y: 1),
            BarChartDataEntry(x: 2, y: 3)
        ])
        
        // table data
        lowercase.data = BarChartData(dataSet: set)
        uppercase.data = BarChartData(dataSet: set)
        chapter.data = BarChartData(dataSet: set)
        activityC.data = BarChartData(dataSet: set)
        
        // adding all of the views
        view.addSubview(scrollView)
            scrollView.addSubview(overview)
                overview.addSubview(recent)
                overview.addSubview(mastered)
                overview.addSubview(time)
                overview.addSubview(activity)
                overview.addSubview(totalTime)
                overview.addSubview(highest)
                overview.addSubview(lowest)
                overview.addSubview(overallAccuracy)
            scrollView.addSubview(uppercaseAccuracy)
                uppercaseAccuracy.addSubview(uppercase)
            scrollView.addSubview(lowercaseAccuracy)
                lowercaseAccuracy.addSubview(lowercase)
            scrollView.addSubview(chapterAccuracy)
                chapterAccuracy.addSubview(chapter)
            scrollView.addSubview(activityPoints)
                activityPoints.addSubview(activityC)
    }
}

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
}
