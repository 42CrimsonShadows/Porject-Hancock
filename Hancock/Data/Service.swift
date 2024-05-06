//
//  Service.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import Foundation
import UIKit

public var currentTeacher : String = ""
public var currentStudent : String = ""
public var currentSession : Int = 0

private var characterToReport : String = ""


class Service {
    
    //MARK: --CREATE(POST)
    //All these functions are created for adding new entries to the database
     
    //MARK: -- UPDATED AUTH
    func CreateManager(firstName: String, lastName: String, pin: String) {
        //Get local storage
        var temp = DecodeData()
        //Create new teacher object
        let newTeacher = TeacherStruct(pin: pin, students: [:])
        //Add OR Update new teacher object in storage
        temp.teachers.updateValue(newTeacher, forKey: lastName + "_" + firstName)
        //Update Storage Object
        EncodeData(DataToEncode: temp)
        
    }
    
    func CreateStudent(firstName: String, lastName: String) {
        //Get local storage
        var temp = DecodeData()
        //Create new teacher object
        let newStudent = StudentStruct(sessions: [])
        //Add OR Update new teacher object in storage
        temp.teachers[currentTeacher]?.students.updateValue(newStudent, forKey: lastName + "_" + firstName)
        //Update Storage Object
        EncodeData(DataToEncode: temp)

    }
    
    func GetCurrentManager() -> String {
        return currentTeacher
    }
    
    func GetCurrentStudent() -> String {
        return currentStudent
    }
    
    func GetPin() -> String {
        let tempStorage = DecodeData()
        return tempStorage.teachers[currentTeacher]?.pin ?? ""
    }
    
    func SetCurrentStudent(studentName: String) {
        currentStudent = studentName
    }
    
    func DeleteManager(pin: String) -> Bool{
        var tempStorage = DecodeData()
        if(tempStorage.teachers[currentTeacher] != nil && tempStorage.teachers[currentTeacher]?.pin == pin) {
            tempStorage.teachers.removeValue(forKey: currentTeacher)
            EncodeData(DataToEncode: tempStorage)
            LogOutManager()
            return true
        }
        return false
    }
    
    func DeleteStudent(studentName : String, pin: String) -> Bool{
        print("name: " + studentName + ", pin: " + pin)
        var tempStorage = DecodeData()
        if(tempStorage.teachers[currentTeacher]?.students[studentName] != nil && tempStorage.teachers[currentTeacher]?.pin == pin) {
            tempStorage.teachers[currentTeacher]?.students.removeValue(forKey: studentName)
            EncodeData(DataToEncode: tempStorage)
            LogOutStudent()
            return true
        }
        return false
    }
    
    // func DisplayStudentData(){}
    
    func ManagerLogin(username: String, pin : String) -> Bool{
       let tempStorage = DecodeData()
        if(tempStorage.teachers[username] != nil && tempStorage.teachers[username]?.pin == pin) {
            currentTeacher = username
            return true
        }
        return false
   }
    
     func StudentLogin(studentName: String) -> Bool{
        var tempStorage = DecodeData()
         if(tempStorage.teachers[currentTeacher]?.students[studentName] != nil) {
             SetCurrentStudent(studentName: studentName)
             let newSession = SessionStruct(date: Date(), letter: [], imitation: [], freeDraw: [])
             tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions.append(newSession)
             currentSession = (tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions.count ?? 1) - 1
             
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
             dateFormatter.timeZone = TimeZone.current
             let localDateString = dateFormatter.string(from: Date())
             
             print(String(currentSession) + " : " + localDateString)
             EncodeData(DataToEncode: tempStorage)
             return true
         }
         return false
    }
    
    func LogOutManager() {
        currentSession = 0
        currentStudent = ""
        currentTeacher = ""
    }
    
    func LogOutStudent() {
        var tempStorage = DecodeData()
        var current = tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession]
        if(current?.letter.count == 0 && current?.imitation.count == 0) {
            //If session is empty remove it
            tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions.remove(at: currentSession)
            EncodeData(DataToEncode: tempStorage)
        }
        currentSession = 0
        currentStudent = ""
    }
    
     func GetManagers() -> [String] {
        var managers : [String] = []
        let storage = DecodeData()
        for (key, value) in storage.teachers {
            managers.append(key)
        }
        return managers
    }
    
    func GetStudents() -> [String] {
        var studentsArray : [String] = []
        let storage = DecodeData()
        for (key, value) in storage.teachers[currentTeacher]?.students ?? [:] {
            studentsArray.append(key)
        }
        print(studentsArray)
        return studentsArray
    }
    
    static func AttemptLogin(username: String, pin: String) -> Bool{
        //make function work for both manager and student
        //TODO compare passed kvp to defaults in localstorage
        return true
        //TODO if kvp matches segue to app
    }
    //END SECTION
    
    //Upload line accuracy and time to complete
    func updateCharacterData(letter: String, faults: Int32, totalPointsEarned: Int32, totalPointsPossible: Int32, image: String){
        
        var tempStorage: LocalStorage = DecodeData()

            // Pass in faults later
        let letterStruct = LetterStruct(letter: letter, tokens: totalPointsEarned, possibleTokens: totalPointsPossible, faults: faults, offpath_image: image)
        
        tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].letter.append(letterStruct)
        print(letterStruct)
        EncodeData(DataToEncode: tempStorage)
    }
    
    //Function to upload imgs
        
    func updateImageData(base64: String, title: String, description: String){
        
        var tempStorage: LocalStorage = DecodeData()
            if(title == "Free Draw"){
                if(tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession] != nil) {
                    tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].freeDraw.append(base64)
                    //print("appended: " + base64)
                }
                else {
                    print("no such session")
                }
            }
            else{
                print("This is your data " + title)
                let tempImitation = LetterStruct(letter: title, tokens: -1, possibleTokens: -1, faults: -1, offpath_image: base64)
                tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].imitation.append(tempImitation)
            }
        
        EncodeData(DataToEncode: tempStorage)
    }
    //MARK: -- VIEW DATA
    func SetCharacterToReport(character: String) {
        characterToReport = character
    }
    func GetCharacterToReport() -> String {
        return characterToReport
    }
    func PrintAllReports() {
        let characters = possibleExercises
        var reports: [String : Int32] = [:]
        for character in characters {
            reports.updateValue(Int32(GetCharacterReport(character: character).count), forKey: character)
        }
        print(reports)
    }
    func GetCharacterReport(character: String) -> [CharacterReport] {
        let tempStorage: LocalStorage = DecodeData()
        if let currentStudentSessions = tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions {
            //Global stats
            var reports: [CharacterReport] = []
            
            for session in currentStudentSessions {
                // Access session safely
//                print("currentStudentSessions: ", currentStudentSessions)
                //Session Stats
                var sessionCharacterReport = CharacterReport(date: session.date, totalScore: 0, totalPossibleScore: 0, totalFaults: 0, attemptCount: 0, attempts: [])
                for attempt in session.letter {
                    if(attempt.letter == character) {
                        sessionCharacterReport.attempts.append(attempt)
                        sessionCharacterReport.attemptCount += 1
                        sessionCharacterReport.totalPossibleScore += attempt.possibleTokens
                        sessionCharacterReport.totalScore += attempt.tokens
                        sessionCharacterReport.totalFaults += attempt.faults
                    }
                }
                
//                for imitation in session.imitation {
//                    if(imitation.letter == character) {
//                        sessionCharacterReport.attempts.append(imitation)
//                    }
//                }
                if(sessionCharacterReport.attempts.count > 0) {
                    reports.append(sessionCharacterReport)
                }
            }
            return reports
        } else {
            print("currentStudentSessions is nil or invalid")
        }
        return []
    }
//    func GetFreeDrawReport() -> [String] {
//        
//    }
    
    //MARK: --READ(GET)
    //These functions will return a value from the database
    static func getObject(id: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = TimeReport(date: Date(), recentAct: "A", timeInapp: "3m 10s", timeInActs: "3m 10s")
        do{
            let endpoint = "https://abcgoapp.org/api/"+id
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "PUT"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
        
    }
    //MARK: --UPDATE(PUT)
    //These will edit an existing entry in the database
    
    
    static func pushData(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = TimeReport(date: Date(), recentAct: "A", timeInapp: "3m 10s", timeInActs: "3m 10s")
        do{
            let endpoint = "https://abcgoapp.org/api/users/register"
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "PUT"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
    }
    
    //MARK: --Destroy(DELETE)
    //These will remove an entry from the database1
    
    //MARK: -- Analytics: TIME
    //static var lastActive = Date() //Need to get it from the DB
    //var timeSinceActive =
    var lastInactive = Date() //Need to get it from the DB
    var lastActiveSession = Date()
    
    static func StartSession(date: Date){
        var lastActive = date
        let timeSinceActive = Date()
        print("Most recent session:",lastActive)
        
    }
    static func TimeSinceActive(lastActive: Date) -> Int32 {
        let currentTime = Date()
        print("Offset:", currentTime.seconds(from: lastActive))
        print("Current Time:", currentTime)
        print("Star Time:", startTime)
        return currentTime.seconds(from: lastActive)
        
    }
    
    //MARK : -- Analyics: ACTIVITY
}

extension Date {
    
    func years(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0)
    }
    func months(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0)
    }
    func days(from date: Date) -> Int32{
        return Int32(Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0)
    }
    func hours(from date: Date) -> Int32{
        return Int32(Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0)
    }
    func minutes(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0)
    }
    func seconds(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)
    }
}

func EncodeData(DataToEncode: LocalStorage) {
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = .prettyPrinted
    
//    let defaults: Void = UserDefaults.standard.setValue(DataToEncode, forKey: "Storage")
    UserDefaults.standard.set(try? PropertyListEncoder().encode(DataToEncode), forKey: "Storage")
//    do{
//        //let data = try encoder.encode(DataToEncode)
//    }
//    catch{
//        print("It Broke")
//    }
}

func DecodeData() -> LocalStorage {
    do{
        if let data = UserDefaults.standard.value(forKey:"Storage") as? Data {
            return try! PropertyListDecoder().decode(LocalStorage.self, from: data)
        }
        else{
            let tempStorage: LocalStorage = LocalStorage()
            EncodeData(DataToEncode: tempStorage)
            return tempStorage
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
    
//    func offset(from date: Date) -> Int32 {
        //var time: Int32 = 0
//        if years(from: date) > 0 { return []}
//        if months(from: date) > 0 { return [] }
//        if days(from: date) > 0 {return [] }
//        if hours(from: date) > 0 {time[0] = date.hours(from: lastActive) }
//        if minutes(from: date) > 0 { time[1] = date.minutes(from: lastActive) }
        //if seconds(from: date) > 0 { return date.seconds(from: lastActive) }
//        print(time)
//        return seconds(from: date)
//    }


//extension NSDate {
//    func hour() -> Int{
//
//        //Get Hour
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(.Hour, fromDate: self)
//        let hour = components.hour
//
//        return hour
//    }
//}



