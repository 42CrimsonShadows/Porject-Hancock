//
//  ActivitySelection.swift
//  Hancock
//
//  Created by Casey Kawamura  on 7/9/19.
//  Copyright © 2019 Chris Ross. All rights reserved.
//

import Foundation
import UIKit

public var currentStep = [[CGPoint]]()
public var activityPoints = [[CGFloat(0),CGFloat(0)]]
public var letterUnderlay = UIImageView()

public class ActivitySelection {
    
    
   
    

    
    public func loadActivityA() {
        //MARK: -- Questions
            // How to we make a system to change steps modularly?
            
        print("Called loadActivityA")
        //add the points that will be used as startingpoint and target point to an array
        //A,B,C,D,E
        activityPoints = [[CGFloat(0.5),CGFloat(0.15)],[CGFloat(0.1), CGFloat(0.85)],[CGFloat(0.9),CGFloat(0.85)],[CGFloat(0.2),CGFloat(0.65)],[CGFloat(0.8),CGFloat(0.65)]]
        
        print("The activity has points at: ", activityPoints)
        //Set the underlay variables
        
            let UnderlayA = UIImage(named: "art.scnassets/LetterImages/A.png")
            letterUnderlay = UIImageView(image: UnderlayA)
            //this enables autolayout for our letter1UnderlayView
            letterUnderlay.translatesAutoresizingMaskIntoConstraints = false
       
       
        //add the sounds to dictionary with a key ["name":"audiofile"]
        
        
    }
    
    public func loadActivityB() {
        print("Called loadActivityB")
        let UnderlayB = UIImage(named: "art.scnassets/LetterImages/B.png")
        letterUnderlay = UIImageView(image: UnderlayB)
        //this enables autolayout for our letter1UnderlayView
        letterUnderlay.translatesAutoresizingMaskIntoConstraints = false
    }
}
