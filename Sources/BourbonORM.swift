//
//  BourbonORM.swift
//  HBApi
//
//  Created by Sean Zhang on 9/8/17.
//
//

import PerfectLib
import MongoDBStORM
import StORM

class BourbonORM: MongoDBStORM{
    
    //static let registerName = "bourbon"
    
    
    var id: String = ""
    var name: String = ""
    var proof: Double = 0.0
    var price: Double = 0.0
    var rating: Int = 0
    var taste: String = ""
    var imageUrl: String = ""
    
    override init() {
        super.init()
        _database = "mydb"
        _collection = "bourbon"
    }
    
    
    override func to(_ this: StORMRow) {

        
        id = this.data["_id"] as? String ?? ""
        name = this.data["name"] as? String ?? ""
        proof = this.data["proof"] as? Double ?? 0.0
        price = this.data["price"] as? Double ?? 0.0
        rating = this.data["rating"] as? Int ?? 0
        taste = this.data["taste"] as? String ?? ""
        imageUrl = this.data["imageUrl"] as? String ?? ""
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



