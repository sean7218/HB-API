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



func findHorse(name: String) throws -> HorseORM {
    
    let getObj = HorseORM()
    var findObj = [String: Any]()
    findObj["name"] = name
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding HorseORM object name: \(getObj.name) and speed: \(getObj.speed) and earning: \(getObj.earning)")
    return getObj
}

func isHorseExist(name: String) throws -> Bool {
    do {
        let horse = try findHorse(name: name)
        if horse.id.characters.count > 0 || horse.name.characters.count > 0 {
            return true
        } else {
            return false
        }
    } catch {
        throw error
    }
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

func isBourbonExist(name: String) throws -> Bool {
    do {
        let b = try findBourbon(name: name, rating: nil)
        if b.id.characters.count > 1 || b.name.characters.count > 1 {
            return true
        } else {
            return false
        }
    } catch {
        throw error
    }
}




