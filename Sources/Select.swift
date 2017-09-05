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


func findHorseByName(name: String) throws -> () {
    
    let getObj = HorseORM()
    var findObj = [String: Any]()
    findObj["name"] = name
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding HorseORM object name \(String(describing: findObj["name"]))")
}


func findBourbon(name: String?, price: Double?, proof: Double?, rating: Int?) throws -> BourbonORM {
    
    let getObj = BourbonORM()

    var findObj = [String: Any]()
    findObj["name"] = name
    findObj["proof"] = proof
    findObj["price"] = price
    findObj["rating"] = rating
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding BourbonORM object id: \(getObj.id) and name \(getObj.name) and proof \(getObj.proof)")
    return getObj
}
