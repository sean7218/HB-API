//
//  RaceORM.swift
//  HBApi
//
//  Created by Sean Zhang on 9/8/17.
//
//
import Foundation
import StORM
import MySQLStORM


class Race: MySQLStORM {
    var id: Int = 0
    var name: String = ""
    var first: String = ""
    var second: String = ""
    var third: String = ""
    
    override func table() -> String {
        return "race"
    }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as? Int ?? 0
        name = this.data["name"] as? String ?? ""
        first = this.data["first"] as? String ?? ""
        second = this.data["second"] as? String ?? ""
        third = this.data["third"] as? String ?? ""
    }
    
    func rows() -> [Race] {
        var rows = [Race]()
        for i in 0..<self.results.rows.count {
            let row = Race()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}


func findRace(name: String) throws  -> Race {
    let getRace = Race()
    do {
        try getRace.select(whereclause: "name = ?", params: [name], orderby: ["id"])
        
        for row in getRace.rows() {
            print(" First: \(row.first) : Second: \(row.second) : Third: \(row.third)")
        }
    } catch {
        print("error for select from database: \(error)")
        throw error
    }
    return getRace
}

func findAllRaces() throws -> Void {
    let race = Race()
    do {
        try race.findAll()
        for i in race.rows() {
            print("FindAllRace: \(i.first)")
        }
    } catch {
        throw error
    }
}


