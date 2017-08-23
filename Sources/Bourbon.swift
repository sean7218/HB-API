//
//  Bourbon.swift
//  HBApi
//
//  Created by Sean Zhang on 8/18/17.
//
//

import PerfectLib
import PerfectHTTP
import MongoDB



public class Bourbons {
    // Container for array of type Person
    var data = [Bourbon]()
    
    // Populating with a mock data object
    init(){
        data = [
            Bourbon(name: "Woodford Reserve", taste: "Good", proof: "90.1"),
            Bourbon(name: "Jim Beam", taste: "Good", proof: "93.1")
        ]
    }
    
    // A simple JSON encoding function for listing data members.
    // Ordinarily in an API list directive, cursor commands would be included.
    public func list() -> String {
        return toString()
    }
    
    // Accepts the HTTPRequest object and adds a new Person from post params.
    public func add(_ request: HTTPRequest) -> String {
        let new = Bourbon(
            name: request.param(name: "name")!,
            taste: request.param(name: "taste")!,
            proof: request.param(name: "proof")!
        )
        data.append(new)
        return toString()
    }
    
    // Accepts raw JSON string, to be converted to JSON and consumed.
    public func add(_ json: String) -> String {
        do {
            let incoming = try json.jsonDecode() as! [String: String]
            let new = Bourbon(
                name: incoming["Name"]!,
                taste: incoming["taste"]!,
                proof: incoming["proof"]!
            )
            data.append(new)
        } catch {
            return "ERROR"
        }
        return toString()
    }
    
    
    // Convenient encoding method that returns a string from JSON objects.
    private func toString() -> String {
        var out = [String]()
        
        for m in self.data {
            do {
                out.append(try m.jsonEncodedString())
            } catch {
                print(error)
            }
        }
        return "[\(out.joined(separator: ","))]"
    }
    
}

public class Bourbon: JSONConvertibleObject {
    
    var name: String = ""
    var taste: String = ""
    var proof: String = ""
    
    init(name: String, taste: String, proof: String) {
        self.name = name
        self.taste = taste
        self.proof = proof
    }
}

