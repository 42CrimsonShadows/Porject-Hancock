//
//  Service.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import Foundation


class Service {
    
    
    var username: String = ""
    var password: String = ""
    
    //MARK: --CREATE(POST)
    //All these functions are created for adding new entries to the database
    
    //Register new users
    static func register (firstName: String, lastName: String, email: String, username: String, password: String, _ completionHandler: @escaping (_ isSuccess:Bool)-> Void) {
        // escaping the completionHandler allows the closure to be called in RegisterViewController after this function has completed
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let user = Student(type: "Student", firstName: firstName, lastName: lastName, email: email, username: username, password: password)
        //let test = Student(type: "Student", firstName: "Student1", lastName: "testing", username: "Student1", password: "Test")
        do{
            let endpoint = "https://abcgoapp.org/api/users/register"
            let data = try encoder.encode(user)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "POST"
            request.httpBody = data
            var code = 0
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let HTTPResponse = response as? HTTPURLResponse
                {
                    code = HTTPResponse.statusCode // only returns 200 on successful registration
                    print(code)
                    switch code {
                    case 200:
                        completionHandler(true) // this is what gets set to success bool in RegisterViewController
                    default:
                        completionHandler(false)
                    }
                }
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
    }
    
    // Login funcation
    static func login(username:String, password:String,_ completionHandler: @escaping (_ isSuccess:Bool)-> Void) {
        // escaping the completionHandler allows the closure to be called in SignInViewController after this function has completed
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let user = Credentials(username:username, password:password)
        //let test = Student(type: "Student", firstName: "Student1", lastName: "testing", email: "email", username: "Student1", password: "Test")
        do{
           
            var teacher: TeacherStruct = TeacherStruct()
            var studented: StudentStruct = StudentStruct()
            var masters: AccuracyStruct = AccuracyStruct()
            var sessions: SessionStruct = SessionStruct()
            var bestAreas: AccuracyStruct = AccuracyStruct()
            var needsWork: AccuracyStruct = AccuracyStruct()
            var iStruct: InfoStruct = InfoStruct(bestLetter: bestAreas, worstLetter: needsWork)
            var lStruct: LetterStruct = LetterStruct()
            var lAtemptStruct: LetterAttemptStruct = LetterAttemptStruct()
            var chapter: ChapterStruct = ChapterStruct(info: iStruct)
            var imitationStruct: ImitationStruct = ImitationStruct()
            
            masters.letter = "a"
            masters.accuracy = "30%"
            
            bestAreas.accuracy = "4%"
            bestAreas.letter = "c"
            
            needsWork.accuracy = "1%"
            needsWork.letter = "p"
            
            iStruct.chapterAvgAcc = 34
            iStruct.chapterTimeSpend = 7
            iStruct.chatpterBestAcc = 3
            
            lAtemptStruct.accuracy = 42
            lAtemptStruct.pointsEarned = 2
            lAtemptStruct.pointsPossible = 6
            lAtemptStruct.score = 43
            lAtemptStruct.timeSpent = 5
            
            lStruct.averageAcc = 6
            lStruct.averageTime = 35
            lStruct.bestAcc = 3
            lStruct.attempts = [lAtemptStruct.self]

            imitationStruct.image = "awddawdawadwdwwww"
            imitationStruct.letter = "freedraw"

            chapter.info = iStruct.self
            chapter.activites = [lStruct.self]
            
            sessions.bestAreas = [bestAreas.self]
            sessions.needsWork = [needsWork.self]
            sessions.chapters = [chapter.self]
            sessions.date = "2/9/2024"
            sessions.freedraws = ["231ewqqwe32423e"]
            sessions.imitation = [(imitationStruct.self)]
            sessions.timeSpentinApp = 9
            
            studented.sessions = [sessions.self]
            studented.masters = [masters.self]
            
            teacher.pin = "1234"
            teacher.students = [studented.self]
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let teacherData = try encoder.encode(teacher)
            print(teacherData)
            
            let defaults = UserDefaults.standard
            defaults.set(teacherData, forKey: "teacher")
            
            let deencoder = JSONDecoder()
            let deCodeData = try deencoder.decode(TeacherStruct.self, from: defaults.data(forKey: "teacher")!)
            print(defaults)
                        
            print(deCodeData)
            print(deCodeData.students[0].sessions[0].chapters[0].activites[0].attempts[0].score)
            
            let endpoint = "https://abcgoapp.org/api/users/authenticate"
            let data = try encoder.encode(user)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")
                
                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "POST"
            request.httpBody = data
            var code = 0
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                //print(response)
                if let HTTPResponse = response as? HTTPURLResponse
                {
                    print(HTTPResponse)
                    code = HTTPResponse.statusCode // only set to 200 on authorized login
                    switch code {
                    case 200:
                        completionHandler(true) // this is what success bool is set to in SignInViewController
                    default:
                        completionHandler(false)
                    }
                }
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    //print(error.localizedDescription)
                }
            }.resume()
             return
        
        } catch {
            print("Could not encode")
            return
        }
    }
    
    //MARK: -- UPDATED AUTH
    func CreateManager(firstName: String, lastName: String, pin: String) {
        var newTeacher = TeacherStruct(pin: pin, students: [])
        //TODO add to defaults
    }
    func CreateStudent(firstName: String, lastName: String, pin: String) {
        var newStudent = StudentStruct()
        //TOOD add student properties, bind to current teacher
    }
    // func DeleteUser(){} make work for both student and manager
    
    // func DisplayStudentData(){}
    
    func AttemptLogin(username: String, pin: String) {
        //make function work for both manager and student
        //TODO compare passed kvp to defaults in localstorage
        
        //TODO if kvp matches segue to app
    }
    //END SECTION
    
    //Upload line accuracy and time to complete
    static func updateCharacterData(username: String, password: String, letter: String, score: Int32, timeToComplete: Int32, totalPointsEarned: Int32, totalPointsPossible: Int32){
        

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = SingleActivityReport(username: username, password: password, letter: letter, score: score, timeToComplete: timeToComplete, totalPointsEarned: totalPointsEarned, totalPointsPossible: totalPointsPossible)
        
        do
        {
            let deencoder = JSONDecoder()
            let data = try encoder.encode(test)
            print(test.password)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "datatest")
            
            let isTestMode = defaults.data(forKey: "datatest")
            let characterJSON = try deencoder.decode(SingleActivityReport.self, from: isTestMode!)
            let characterString = String(decoding: isTestMode!, as: UTF8.self)
            
            print("Letter was " + characterJSON.letter + " from the json " + characterString)
        
        } 
        catch {
            print("Could not encode")
        }
    }
    
    //Function to upload imgs
    static func updateImageData(username: String, password: String, base64: String, title: String, description: String){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = SingleImageReport(username: username, password: password, base64: base64, title: title, description: description)
        do
        {
            let deencoder = JSONDecoder()
            let defaults = UserDefaults.standard

            var deCodeData = try deencoder.decode(TeacherStruct.self, from: defaults.data(forKey: "teacher")!)
            
            deCodeData.students[0].sessions[0].freedraws.append(base64)
            
            print(deCodeData)
            
        }
        catch {
            print("Could not encode")
        }
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
}

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



