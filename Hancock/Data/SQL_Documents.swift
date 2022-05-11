//
//  SQL_Documents.swift
//  Hancock
//
//  Created by Jon Kido on 5/11/22.
//  Copyright © 2022 Chris Ross. All rights reserved.
//

import Foundation

// MARK: --- DBUsers
class DBUsers: Codable {
    var firstname : String?
    var lastname : String?
    var password : String?
    var userID : Int?
}

// MARK: --- DBCharacters
class DBCharacters: Codable {
    var userID : Int?
    var letter : String?
    var date : Date?
    var timeID: Int?
    var accuracy: Double?
    var points: Int
}

// MARK: --- DBTimeSegments
class DBTimeSegments: Codable{
    var timeID: Int?
    var segment: Int?
    var time: Double?
}

// MARK: --- DBSession
class DBSessions: Codable{
    var startDate: Double?
    var endDate: Double?
    var userID: Int?
}

// MARK: --- DBChapter
class DBChapter{
    static var One = ["I","T","L","F","E","H"]
    static var Two = ["P","R","B","C","D","U"]
    static var Three = ["G","O","Q","S","J"]
    static var Four = ["K","V","W","M","A"]
    static var Five = ["N","Z","Y","X"]
    static var Six = ["c","a","d","g","o"]
    static var Seven = ["u","s","v","w","i","t"]
    static var Eight = ["l","y","k","e","j"]
    static var Nine = ["b","r","n","h","p","m"]
    static var Ten = ["f","q","x","z"]
    
    static func Get(chapter:Int) -> [String] {
        switch(chapter){
        case 1:
            return self.One
        case 2:
            return self.Two
        case 3:
            return self.Three
        case 4:
            return self.Four
        case 5:
            return self.Five
        case 6:
            return self.Six
        case 7:
            return self.Seven
        case 8:
            return self.Eight
        case 9:
            return self.Nine
        case 10:
            return self.Nine
        default:
            return []
        }
    }
}
