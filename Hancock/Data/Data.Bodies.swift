//
//  User.body.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import Foundation

//This struct will be the foundation for a new user.

//The register form should include all of the fields
//MARK: -- USER SCHEMA
struct Student: Codable {
    var type: String
    var firstName: String
    var lastName: String
    var username: String
    var password: String
}

struct Teacher: Codable {
    var type: String
    var TOKEN: String
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
    var email: String
}

struct Parent: Codable {
    var type: String
    var TOKEN: String
    var email: String
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
}

struct Doctor: Codable {
    var type: String
    var TOKEN: String
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
    var email: String
}

struct Admin: Codable {
    var type: String
    var TOKEN: String
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
    var email: String
}


//MARK: --Reports

//MARK: --Time reports
struct TimeReport: Codable {
    var date: Date
    var recentAct: String
    //MARK: --QUESTION
    //Can time be reported as a type other than float? Should this be a string? DateTime?
    var timeInapp: String
    var timeInActs: String
    //var avgTimePerActAtt: [Float32]
    //var timeSpentActs: [Float32]
    //var timeSpentDuration: [Float32]
    //var thisWeeksActivity: [Float32]
}

//MARK: --Activity reports

struct TotalActivityReport: Codable {
    var date: String
    var avgAccPerChap: [Float32]
    var avgAccPerLetter: [Float32]
    var avgAccOverall: [Float32]
    var pointsPerAct: [Float32]
    var totalPointsEarned: Int
    var totalAtt: Int
    var bestAreas: String
    var worstAreas: String
    var needsWork: String
    
    //Should just be displayed over total number of activitys(52)
    var actsMastered: Int
}

//Should be edited and added for each attempt of the activity.
struct SingleActivityReport: Codable {
    var username: String
    var password: String
    //var date: String
    var letter: String
    //var Chapter: String
    var score: Int32
    var timeToComplete: Int32
    var totalPointsEarned: Int32
    var totalPointsPossible: Int32
    
}



//MARK: --Progress reports
// I think this might be done on the website.




