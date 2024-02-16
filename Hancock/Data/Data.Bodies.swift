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

//Chapters with contained letters
struct chapter: Codable {
    var chap1 = ["a", "b", "c"]
    var chap2 = ["d", "e", "f"]
}

//Different rows to append to overall storage

struct ChapterStruct: Codable {
    var info: InfoStruct  //info struct goes here
    var activites: [LetterStruct] = []
}

struct LetterStruct: Codable {
    var attempts: [LetterAttemptStruct] = []
    var bestAcc = 0
    var averageAcc = 0
    var averageTime = 0
}

struct ImitationStruct: Codable{
    var letter = ""
    var image = ""
}

struct LetterAttemptStruct: Codable {
    var accuracy = 0
    var pointsEarned = 0
    var pointsPossible = 0
    var score = 0
    var timeSpent = 0
}

struct AccuracyStruct: Codable{
    var letter = ""
    var accuracy = ""
}

struct SessionStruct: Codable {
    var bestAreas: [AccuracyStruct] = [
        //best areas struct here
    ] //Append all letters and accuracy value if above certain value (should be between 0 and 80 based on master, maybe 60?) //Old system just finds best letter
    var needsWork: [AccuracyStruct] = [
        //needs work struct here
    ] //Append all letters and accuracy value if below certain value (should be between 0 and bestArea value, maybe 20?)  //Old system just finds worst letter
    var timeSpentinApp = 7000
    //Get currdate
    var date = "datetime"

    var chapters: [ChapterStruct] = [
        //Chapter structs here
    ]
    var freedraws: [String] = [] //image strings here
    
    var imitation: [ImitationStruct] = []
}

struct InfoStruct: Codable {
    var chapterTimeSpend = 0
    var bestLetter : AccuracyStruct//letter+acc
    var worstLetter : AccuracyStruct//letter+acc
    var chatpterBestAcc = 0
    var chapterAvgAcc = 0
}

struct StudentStruct: Codable {
    var masters: [AccuracyStruct] = [
        //master letter struct here
    ]
    var sessions: [SessionStruct] = [
        //sessionStruct here
    ]
}

struct TeacherStruct: Codable {
    var pin = "0000"
    var students: [StudentStruct] = [
        //sutdent struct here
    ]
}

//MARK: --Progress reports
// I think this might be done on the website.




