//
//  Service.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import Foundation

public var currentTeacher : String = ""
public var currentStudent : String = ""
public var currentSession : Int = 0

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
    
    func DeleteManager(pin: String) -> Bool{
        var tempStorage = DecodeData()
        if(tempStorage.teachers[currentTeacher] != nil && tempStorage.teachers[currentTeacher]?.pin == pin) {
            tempStorage.teachers.removeValue(forKey: currentTeacher)
            LogOutManager()
            return true
        }
        return false
    }
    
    func DeleteStudent(studentName : String, pin: String) -> Bool{
        var tempStorage = DecodeData()
        if(tempStorage.teachers[currentTeacher]?.students[studentName] != nil && tempStorage.teachers[currentStudent]?.pin == pin) {
            tempStorage.teachers[currentTeacher]?.students.removeValue(forKey: studentName)
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
             currentStudent = studentName
             let newSession = SessionStruct(letter: [], imitation: [], freeDraw: [])
             tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions.append(newSession)
             currentSession = (tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions.count ?? 1) - 1
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
    func updateCharacterData(letter: String, score: Int32, timeToComplete: Int32, totalPointsEarned: Int32, totalPointsPossible: Int32){
        
        var tempStorage: LocalStorage = DecodeData()

            // Pass in faults later
        var letterStruct = LetterStruct(letter: letter, tokens: totalPointsEarned, faults: 0)
        
        tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].letter.append(letterStruct)
        
        EncodeData(DataToEncode: tempStorage)
    }
    
    //Function to upload imgs
        
    func updateImageData(base64: String, title: String, description: String){
        
        var tempStorage: LocalStorage = DecodeData()
        print(tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].freeDraw)
            if(title == "Free Draw"){
                tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].freeDraw.append(base64)
            }
            else{
                print("This is your data " + title)
                let tempImitation = ImitationStruct(letter: title, image: base64)
                tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].imitation.append(tempImitation)
            }
        
        EncodeData(DataToEncode: tempStorage)
        print(tempStorage.teachers[currentTeacher]?.students[currentStudent]?.sessions[currentSession].freeDraw)
    }
    
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



