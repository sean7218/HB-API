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



//public class Bourbons {
//    // Container for array of type Person
//    var data = [Bourbon]()
//    
//    // Populating with a mock data object
//    init(){
//        data = [
//            Bourbon(name: "Woodford Reserve", price: 30.0, proof: 80.1, rating: 500, taste: "Awesome", imageUrl: ""),
//            Bourbon(name: "Wild Turkey", price: 34.0, proof: 91.2, rating: 400, taste: "Pefect", imageUrl: "")
//
//        ]
//    }
//    
//    // A simple JSON encoding function for listing data members.
//    // Ordinarily in an API list directive, cursor commands would be included.
//    public func list() -> String {
//        return toString()
//    }
//    
//    // Accepts the HTTPRequest object and adds a new Person from post params.
//    public func add(_ request: HTTPRequest) -> String {
//        let new = Bourbon(
//            name: request.param(name: "name")!,
//            price: 40.2,
//            proof: 100.1,
//            rating: 400,
//            taste: request.param(name: "taste")!,
//            imageUrl: request.param(name: "imageUrl")!
//        )
//        data.append(new)
//        return toString()
//    }
//    
//    // Accepts raw JSON string, to be converted to JSON and consumed.
//    public func add(_ json: String) -> String {
//        do {
//            let incoming = try json.jsonDecode() as! [String: String]
//            let new = Bourbon(
//                name: incoming["Name"]!,
//                price: 40.2,
//                proof: 100.1,
//                rating: 400,
//                taste: incoming["taste"]!,
//                imageUrl: incoming["imageUrl"]!
//            )
//            data.append(new)
//        } catch {
//            return "ERROR"
//        }
//        return toString()
//    }
//    
//    
//    // Convenient encoding method that returns a string from JSON objects.
//    private func toString() -> String {
//        var out = [String]()
//        
//        for m in self.data {
//            do {
//                out.append(try m.jsonEncodedString())
//            } catch {
//                print(error)
//            }
//        }
//        return "[\(out.joined(separator: ","))]"
//    }
//    
//}


class Bourbon: JSONConvertibleObject {
    
    static let registerName = "bourbon"
    
    var name = ""
    var price = 0.0
    var proof = 0.0
    var rating = 0
    var taste = ""
    var imageUrl = ""
    
//    init(name: String, price: Double, proof: Double, rating: Int, taste: String, imageUrl: String) {
//        self.name = name
//        self.price = price
//        self.proof = proof
//        self.rating = rating
//        self.taste = taste
//        self.imageUrl = imageUrl
//    }
    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.price = getJSONValue(named: "price", from: values, defaultValue: 0.0)
        self.proof = getJSONValue(named: "proof", from: values, defaultValue: 0.0)
        self.rating = getJSONValue(named: "rating", from: values, defaultValue: 0)
        self.taste = getJSONValue(named: "taste", from: values, defaultValue: "")
        self.imageUrl = getJSONValue(named: "imageUrl", from: values, defaultValue: "")
    }
    
    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: Bourbon.registerName,
            "name": self.name,
            "price": self.price,
            "proof": self.proof,
            "rating": self.rating,
            "taste": self.taste,
            "imageUrl": self.imageUrl
        ]
    }
}

