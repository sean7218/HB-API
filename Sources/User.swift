//
//  User.swift
//  HBApi
//
//  Created by Sean Zhang on 8/20/17.
//
//

//import Foundation
import PerfectLib

class User: JSONConvertibleObject {
    
    static let registerName = "user"
    
    var id = ""
    var name = ""
    var imageUrl = ""
    var luck = 0
    
    override func setJSONValues(_ values: [String : Any]) {
        self.id = getJSONValue(named: "id", from: values,  defaultValue: "")
        self.name = getJSONValue(named: "name", from: values, defaultValue:"")
        self.imageUrl = getJSONValue(named: "imageUrl", from: values,  defaultValue: "")
        self.luck = getJSONValue(named: "luck", from: values,  defaultValue: 0)
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: User.registerName,
            "id": self.id,
            "name": self.name,
            "imageUrl": self.imageUrl,
            "luck": self.luck
        ]
    }
}
