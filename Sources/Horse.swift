//
//  Horse.swift
//  HBApi
//
//  Created by Sean Zhang on 8/18/17.
//
//

import Foundation
import PerfectLib

class Horse: JSONConvertibleObject {
    
    static let registerName = "horse"
    
    var breed: String = ""
    var wons: Int = 0
    var name: String = ""
    
    init(name: String, breed: String, wons: Int) {
        self.name = name
        self.breed = breed
        self.wons = wons
    }
    
    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "nameless")
        self.breed = getJSONValue(named: "breed", from: values, defaultValue: "unkown breed")
        self.wons = getJSONValue(named: "wons", from: values, defaultValue: 0)
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: Horse.registerName,
            "name": self.name,
            "breed": self.breed,
            "wons": self.wons
        ]
    }
    

}

