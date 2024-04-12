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
    var email: String
    var username: String
    var password: String
}

struct Credentials: Codable {
    var username: String
    var password: String
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

//Should be edited and added for each image.
struct SingleImageReport: Codable {
    var username: String
    var password: String
    var base64: String
    var title: String
    var description: String
}

//Different rows to append to overall storage

struct ImitationStruct: Codable{
    var letter: String = ""
    var image: String = ""
}

struct LetterStruct: Codable{
    var letter: String
    var tokens: Int32
    var possibleTokens: Int32
    var faults: Int32
    var offpath_image: String = ""
}

struct SessionStruct: Codable{
    //Date
    var date: Date
    // Array of letters
    var letter: [LetterStruct]
    
    //var imitation
    var imitation: [ImitationStruct]
    
    // Base64 Images
    var freeDraw: [String]
}

struct StudentStruct: Codable {
    var sessions: [SessionStruct]
}

struct TeacherStruct: Codable {
    var pin = "0000"
    var students: [String : StudentStruct] = [:]
}

struct LocalStorage: Codable{
    var teachers: [String : TeacherStruct] = [:]
}
//MARK: --Progress reports
// I think this might be done on the website.




