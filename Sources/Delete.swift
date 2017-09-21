//
//  Delete.swift
//  HBApi
//
//  Created by Sean Zhang on 9/20/17.
//
//

import Foundation
import StORM
import MongoDBStORM


/* =============================================================================================
 Deleting object
 ============================================================================================= */
func deleteObjectByName(name: String) throws {
    
    let objForDelete = BourbonORM()
    
    do {
        if (try isBourbonExist(name: name)) {
            let obj = try findBourbon(name: name, rating: nil)
            try objForDelete.get(obj.id)
            try objForDelete.delete()
        } else {
            print("The bourbon doesn't exist, delete operation fail")
        }

    } catch {
        
        print("There was error deleting object \(error)")
        throw error
    }
    print("'deleteObjectByID' - Object deleted, id \(objForDelete.id)")
    
}
