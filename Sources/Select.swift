//
//  Select.swift
//  HBApi
//
//  Created by Sean Zhang on 9/2/17.
//
//

import Foundation
import StORM
import MongoDBStORM

func findByString(name: String) throws -> () {
    
    let getObj = DataSource()
    var findObj = [String: Any]()
    findObj["name"] = name
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding object name \(String(describing: findObj["name"]))")
}


func findHorse(name: String) throws -> () {
    
    let getObj = HorseORM()
    var findObj = [String: Any]()
    findObj["name"] = name
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding HorseORM object name: \(getObj.name) and speed: \(getObj.speed) and earning: \(getObj.earning)")
}


func findBourbon(name: String?, rating: Int?) throws -> BourbonORM {
    
    let getObj = BourbonORM()

    var findObj = [String: Any]()
    findObj["name"] = name
    findObj["rating"] = rating
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding BourbonORM object id: \(getObj.id) and name \(getObj.name) and rating \(getObj.rating)")
    return getObj
}

extension Double {
    func trim(digits: Int) -> Double {
        let d = digits
        if digits > 0 {
            let s = 10 * Double(d)
            let v = s * self
            let q = v.rounded()
            let e = q/s
            
            return e
        } else {
            return self.rounded()
        }

    }
}
