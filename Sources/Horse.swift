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
    
    var name = ""
    var earning = ""
    var speed = 0
    
    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.earning = getJSONValue(named: "earning", from: values, defaultValue: "")
        self.speed = getJSONValue(named: "speed", from: values, defaultValue: 0)
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: Horse.registerName,
            "name": self.name,
            "earning": self.earning,
            "speed": self.speed
        ]
    }
    
}
