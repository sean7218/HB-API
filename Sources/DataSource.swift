//
//  DataSource.swift
//  HBApi
//
//  Created by Sean Zhang on 9/2/17.
//
//

import Foundation
import StORM
import MongoDBStORM

class DataSource: MongoDBStORM {
    
    var id: String = ""
    var name: String = ""
    
    override init() {
        super.init()
        _collection = "dataSource"
    }
    
    
    override func to(_ this: StORMRow) {
        id = this.data["_id"] as? String ?? ""
        name = this.data["name"] as? String ?? ""
    }
    
    func rows() -> [DataSource] {
        var rows = [DataSource]()
        for i in 0..<self.results.rows.count {
            let row = DataSource()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
