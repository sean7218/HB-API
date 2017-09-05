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

class BourbonORM: MongoDBStORM {
    var id: String = ""
    var name: String = ""
    var proof: Double = 0.0
    var price: Double = 0.0
    var rating: Int = 0
    
    override init() {
        super.init()
        _database = "mydb"
        _collection = "bourbon"
    }
    
    
    override func to(_ this: StORMRow) {
        let tem = this.data["_id"] as? [String: Any] ?? nil
        id = tem?["$oid"] as? String ?? ""
        name = this.data["name"] as? String ?? ""
        proof = this.data["proof"] as? Double ?? 0.0
        price = this.data["price"] as? Double ?? 0.0
        let tem1 = this.data["rating"] as? Double ?? 0.0
        rating = Int(tem1)
    }
    
    func rows() -> [BourbonORM] {
        var rows = [BourbonORM]()
        for i in 0..<self.results.rows.count {
            let row = BourbonORM()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

class HorseORM: MongoDBStORM {
    var id: String = ""
    var name: String = ""
    var earning: String = ""
    var speed: Int = 0
    
    override init() {
        super.init()
        _collection = "horse"
        _database = "mydb"
    }
    
    override func to(_ this: StORMRow) {
        id = this.data["_id"] as? String ?? ""
        name = this.data["name"] as? String ?? ""
        earning = this.data["earning"] as? String ?? ""
        speed = this.data["speed"] as? Int ?? 0
    }
    
    func rows() -> [HorseORM] {
        var rows = [HorseORM]()
        for i in 0..<self.results.rows.count {
            let row = HorseORM()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

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
