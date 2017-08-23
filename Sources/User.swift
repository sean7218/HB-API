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
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    override func setJSONValues(_ values: [String : Any]) {
        self.username = getJSONValue(named: "username", from: values, defaultValue: "")
        self.email = getJSONValue(named: "email", from: values, defaultValue: "")
        self.password = getJSONValue(named: "password", from: values, defaultValue: "")
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: User.registerName,
            "email": self.email,
            "username": self.username,
            "passpord": self.password
        ]
    }
    
}

