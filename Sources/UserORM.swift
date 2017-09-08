//
//  UserORM.swift
//  HBApi
//
//  Created by Sean Zhang on 9/8/17.
//
//

import MongoDBStORM
import StORM

class UserORM: MongoDBStORM {
    var id: String = ""
    var name: String = ""
    
    override init() {
        super.init()
        _collection = "user"
    }
    
    
    override func to(_ this: StORMRow) {
        name = this.data["name"] as? String ?? ""
        
    }
    
    func rows() throws -> [UserORM] {
        var rows = [UserORM]()
        for i in 0..<self.results.rows.count {
            let row = UserORM()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
