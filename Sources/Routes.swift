//
//  Routes.swift
//  HBApi
//
//  Created by Sean Zhang on 8/18/17.
//
//

import PerfectHTTP
import MongoDB
import PerfectLib

public func makeRoutes() -> Routes {
    var routes = Routes()
    
    routes.add(method: .get, uri: "/api/v1", handler: {
        request, response in
        
        response.completed()
    
    })
    
    routes.add(method: .get, uri: "/api/v1/horse") { (request, response) in
        response.setHeader(.contentType, value: "application/json")
        .appendBody(string: "hello, you will get all the horses")
        .completed()
    }
    
    routes.add(method: .get, uri: "/v1/horse/{name}", handler: {
        request, response in
        
        do {
            try response.setBody(json: ["JIM BEAM":"Fda"])
        } catch {
            print(error)
        }
        response.completed()
        
    })
    
    routes.add(method: .post, uri: "/v1/horse/save", handler: {
        request, response in
        do {
            let client = try MongoClient(uri: "mongodb://localhost:27017")
            let db = client.getDatabase(name: "mydb")
            guard let collection = db.getCollection(name: "horse") else { return }
            
            defer {
                collection.close()
                db.close()
                client.close()
            }
            
            
        } catch {
            Log.error(message: error as! String)
        }
    })
    

    
    routes.add(method: .get, uri: "/v1/mongo", handler: { request, response in
        
        do {
            
            // Open a connection
            let client = try MongoClient(uri: "mongodb://localhost:27017")
            
            // Set database, assuming HBApi exist
            let db = client.getDatabase(name: "mydb")
            
            let col = db.getCollection(name: "mycol")
            
            // Define collection
            guard let collection = db.getCollection(name: "user") else {
                return
            }
            
            
            
            // Here we clean up our connection, by backing out in reverse order created
            defer {
                collection.close()
                db.close()
                client.close()
            }
            
            // Peform "find" on the previous defined collection
            //let query = BSON(map: ["username":"Lucy"])
            //let query2 = BSON(map: ["email":"lucy5@gmail.com"])
            let query3 = BSON()
            let find = collection.find(query: query3)
            
            // Initialize empty array to receive formatted results
            var arr = [String]()
            
            // The "find" cursor is a type MongoCursor, which is iterable
            for x in find! {
                arr.append(x.asString)
                
            }
            
            // return a formmated JSON array
            let returnning = "\"Data\":[\(arr.joined(separator: ","))]"
            response.setBody(string: returnning)
                .completed()
            
        } catch {
            Log.error(message: error as! String)
        }
        
        
    })
    
    return routes
}
