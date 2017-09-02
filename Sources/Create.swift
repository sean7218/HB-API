//
//  Create.swift
//  HBApi
//
//  Created by Sean Zhang on 9/2/17.
//
//

import Foundation
import StORM
import MongoDBStORM


func saveNew(name: String) throws -> DataSource {
    let obj = DataSource()
    obj.id = obj.newUUID()
    obj.name = name
    
    do {
        try obj.save()
    } catch {
        throw error
    }
    print("'saveNew' - Object Created with id \(obj.id)")
    return obj
}
