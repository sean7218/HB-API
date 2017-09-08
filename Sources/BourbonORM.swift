//
//  BourbonORM.swift
//  HBApi
//
//  Created by Sean Zhang on 9/8/17.
//
//

import MongoDBStORM
import StORM

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
        if let tem = this.data["_id"] as? [String: Any]{
            id = tem["$oid"] as? String ?? ""
        } else if let tem = this.data["_id"] as? String {
            id = tem
        } else {
            id = ""
        }
        
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
