//
//  HorseORM.swift
//  HBApi
//
//  Created by Sean Zhang on 9/8/17.
//
//


import MongoDBStORM
import StORM

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
