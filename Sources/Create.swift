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

func saveNewHorse(name: String, earning: String, speed: Int) throws -> HorseORM {
    let obj = HorseORM()
    obj.id = obj.newUUID()
    obj.name = name
    obj.earning = earning
    obj.speed = speed
    
    do {
        try obj.save()
    } catch {
        throw error
    }
    print("'saveNewHorse' - Object Created with id \(obj.id)")
    return obj
}

func saveNewBourbon(name: String, price: Double, proof: Double, rating: Int) throws -> BourbonORM {
    let obj = BourbonORM()
    obj.id = obj.newUUID()
    
    obj.name = name
    obj.price = price
    obj.proof = proof
    obj.rating = rating
    
    
    do {
        try obj.save()
    } catch {
        throw error
    }
    print("'saveNewBourbon' - Object Created with id \(obj.id)")
    return obj
}

func saveNewUser(name: String) throws -> UserORM {
    let obj = UserORM()
    obj.id = obj.newUUID()
    obj.name = name
    
    do {
        try obj.save()
    } catch {
        throw error
    }
    print("'saveNewUser' Object Created with id \(obj.id)")
    return obj
}
