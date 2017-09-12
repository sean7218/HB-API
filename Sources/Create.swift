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
enum ValidationError: Error {
    case incorrectType

}
extension String {
    func validate() throws -> Bool {
        if Double(self) != nil {
            return true
        } else if Int(self) != nil {
            return true
        } else {
            throw ValidationError.incorrectType
        }
    }
}
