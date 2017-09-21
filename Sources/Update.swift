//
//  Update.swift
//  HBApi
//
//  Created by Sean Zhang on 9/5/17.
//
//

import Foundation
import StORM
import MongoDBStORM

func updateBourbon(name: String, price: Double) throws -> () {
    
    if (try isBourbonExist(name: name)) {
        let bourbon = try findBourbon(name: name, rating: nil)
        bourbon.name = name
        bourbon.price = price
        try bourbon.save()
    } else {
        throw ServerError.objectNotExist
    }

}

func updateBourbonTaste(name: String, taste: String, imageUrl: String) throws -> () {
    
    if (try isBourbonExist(name: name)) {
        let bourbon = try findBourbon(name: name, rating: nil)
        bourbon.taste = taste
        bourbon.imageUrl = imageUrl
        try bourbon.save()
    } else {
        throw ServerError.objectNotExist
    }
}
