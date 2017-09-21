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

/* =============================================================================================
 Creating object
 ============================================================================================= */

func saveNewBourbon(name: String, price: Double, proof: Double, rating: Int, taste: String, imageUrl: String) throws -> BourbonORM {
    let obj = BourbonORM()
    obj.id = obj.newUUID()
    
    obj.name = name
    obj.price = price
    obj.proof = proof
    obj.rating = rating
    obj.taste = taste
    obj.imageUrl = imageUrl
    
    do {
        try obj.save()
    } catch {
        throw error
    }
    print("'saveNewBourbon' - Object Created with id \(obj.id)")
    return obj
}


