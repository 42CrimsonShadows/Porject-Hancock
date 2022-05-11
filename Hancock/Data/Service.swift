//
//  Service.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//
//  Reworked by Jon Kido on 5/11/22.
//  SQLite transition from api based

import Foundation
import SQLite3

//MARK: Default SQL classes
class Grade: Codable {
    var id : String?
    var name : String?
    var checked : Bool = false
    var hour : String?
    var grade: String?
    var point : Double = 0.0
}

class DBGrade: Codable {
    var id : Int = 1
    var name : String?
    var result : String?
    var avg : Int?
    var avgType : Int = 4
    var list : [Grade]?
}

class Service {
    
    //MARK: DEFAULT SQL FUNCTIONS ------
    var db : OpaquePointer?
    var path : String = "myDataBaseName.sqlite"
    init() {
        self.db = createDB()
        self.createTable()
    }
    
    //MARK: ----- CREATE DATABASE
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    //MARK: ----- CREATE TABLE
    func createTable()  {
        let query = "CREATE TABLE IF NOT EXISTS your_table_name(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, result TEXT, avg INTEGER, list TEXT);"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation fail")
            }
        } else {
            print("Prepration fail")
        }
    }
    
    //MARK: ----- INSERT
    func insert(name : String, result : String, avg : Int, list : [Grade]) {
            let query = "INSERT INTO your_table_name (id, name, result, avg, list) VALUES (?, ?, ?, ?, ?);"
            
            var statement : OpaquePointer? = nil
            
            var isEmpty = false
            if read(avg: avg).isEmpty {
                isEmpty = true
            }
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                if isEmpty {
                 sqlite3_bind_int(statement, 1, 1)
                }
                sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (result as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 4, Int32(avg))
                
                let data = try! JSONEncoder().encode(list)
                let listString = String(data: data, encoding: .utf8)
                
                sqlite3_bind_text(statement, 5, (listString! as NSString).utf8String, -1, nil)
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Data inserted success")
                }else {
                    print("Data is not inserted in table")
                }
            } else {
              print("Query is not as per requirement")
            }
            
        }
        
    //MARK: ----- READ
        func read(avg : Int) -> [DBGrade] {
            var mainList = [DBGrade]()
            
            let query = "SELECT * FROM your_table_name;"
            var statement : OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                while sqlite3_step(statement) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(statement, 0))
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    let result = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    let avg = Int(sqlite3_column_int(statement, 3))
                    let list = String(describing: String(cString: sqlite3_column_text(statement, 4)))

                    let model = DBGrade()
                    model.id = id
                    model.name = name
                    model.result = result
                    model.avg = avg
                    
                    let data = try! JSONDecoder().decode([Grade].self, from: list.data(using: .utf8)!)
                    
                    model.list = data
                    
                    mainList.append(model)
                }
            }
            return mainList
        }
    
    //MARK: ----- UPDATE
    func update(id : Int, name : String, result : String, avg : Int, list : [Grade]) {
        let data = try! JSONEncoder().encode(list)
        let listString = String(data: data, encoding: .utf8)
        let query = "UPDATE grade SET name = '\(name)', result = '\(result)', avg = \(avg), list = '\(listString!)' WHERE id = \(id);"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
        }
    }
    
    //MARK: ----- DELETE
    func delete(id : Int) {
        let query = "DELETE FROM grade where id = \(id)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: OLD FUNCTIONS ------
    
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
    
    static func login(username:String, password:String,_ completionHandler: @escaping (_ isSuccess:Bool)-> Void) {
        // escaping the completionHandler allows the closure to be called in SignInViewController after this function has completed
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let user = Credentials(username:username, password:password)
        //let test = Student(type: "Student", firstName: "Student1", lastName: "testing", email: "email", username: "Student1", password: "Test")
        do{
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
    
    static func updateCharacterData(username: String, password: String, letter: String, score: Int32, timeToComplete: Int32, totalPointsEarned: Int32, totalPointsPossible: Int32){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = SingleActivityReport(username: username, password: password, letter: letter, score: score, timeToComplete: timeToComplete, totalPointsEarned: totalPointsEarned, totalPointsPossible: totalPointsPossible)
        do{
            let endpoint = "https://abcgoapp.org/api/users/Data"
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "POST"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                print(response)
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
    }
    
    static func updateImageData(username: String, password: String, base64: String, title: String, description: String){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = SingleImageReport(username: username, password: password, base64: base64, title: title, description: description)
        do{
            let endpoint = "https://abcgoapp.org/api/users/Data"
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "PUT"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                print(response)
                if let error = error {
                    print(error)
                }
            }.resume()
        
        } catch {
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



