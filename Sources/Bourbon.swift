//
//  Bourbon.swift
//  HBApi
//
//  Created by Sean Zhang on 8/18/17.
//
//

import PerfectLib
import PerfectHTTP
import StORM
import MongoDB
import MongoDBStORM

class Bourbon: JSONConvertibleObject {
    
    static let registerName = "bourbon"
    
    var name = ""
    var price = 0.0
    var proof = 0.0
    var rating = 0
    var taste = ""
    var imageUrl = ""
    

    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.price = getJSONValue(named: "price", from: values, defaultValue: 0.0)
        self.proof = getJSONValue(named: "proof", from: values, defaultValue: 0.0)
        self.rating = getJSONValue(named: "rating", from: values, defaultValue: 0)
        self.taste = getJSONValue(named: "taste", from: values, defaultValue: "")
        self.imageUrl = getJSONValue(named: "imageUrl", from: values, defaultValue: "")
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: Bourbon.registerName,
            "name": self.name,
            "price": self.price,
            "proof": self.proof,
            "rating": self.rating,
            "taste": self.taste,
            "imageUrl": self.imageUrl
        ]
    }
}




