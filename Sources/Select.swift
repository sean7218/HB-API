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

func findByString() throws -> () {
    
    let getObj = DataSource()
    var findObj = [String: Any]()
    findObj["name"] = "Jim Beam"
    
    do {
        try getObj.find(findObj)
    } catch {
        throw error
    }
    print("Finding object name \(String(describing: findObj["name"]))")
}
