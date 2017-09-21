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




