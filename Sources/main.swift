import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MongoDB
import MongoDBStORM

let server = HTTPServer()

var routes = Routes()

MongoDBConnection.host = "localhost"
MongoDBConnection.database = "mydb"
MongoDBConnection.port = 27017

JSONDecoding.registerJSONDecodable(name: Horse.registerName, creator: { return Horse() })
JSONDecoding.registerJSONDecodable(name: Bourbon.registerName, creator: { return Bourbon() })
JSONDecoding.registerJSONDecodable(name: User.registerName, creator: { return User() })

routes.add(method: .get, uri: "/", handler: {
    request, response in
    // Setting the response content type explicitly to text/html
    response.setHeader(.contentType, value: "text/html")
    // Adding some HTML to the response body object
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    // Signalling that the request is completed
    response.completed()
})

routes.add(method: .get, uri: "/files/**", handler: {
    request, response in
    
    // get the portion of the request path which was matched by the wildcard
    request.path = request.urlVariables[routeTrailingWildcardKey]!
    
    // Initialize the StaticFileHandler with a documentRoot
    let handler = StaticFileHandler(documentRoot: "/Users/mpb15sz/apps/HBApi/public")
    
    // trigger the handling of the request,
    // with our documentRoot and modified path set
    handler.handleRequest(request: request, response: response)
    
    
})

routes.add(method: .get, uri: "/v1/bourbon", handler: {
    request, response in
    
    let wdir = Dir("~/apps/HBApi/Sources/")
    let json = File(wdir.path + "bourbon.json")
    var result = ""
    
    do {
        result = try json.readString()
        let out = try result.jsonDecode()
        try response.setBody(json: out)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
    } catch {
        print(error)
        Log.error(message: "Error Condition \(error)")
    }

})

routes.add(method: .get, uri: "/v1/bourbon/{name}{rating}", handler: {
    request, response in
    let params = request.queryParams
    var name: String?
    var price: Double?
    var rating: Int?
    var proof: Double?
    for i in 0..<params.count {
        switch params[i].0 {
            case "name": name = params[i].1
            case "price": price = Double(params[i].1)
            case "rating": rating = Int(params[i].1)
            case "proof": proof = Double(params[i].1)
            default: break
        }
    }
    
    if let paramName = request.param(name: "name")
    {
        print("Found Name Param : \(paramName)")
    }
    
    if let paramRating = request.param(name: "rating") {
        print("Found Rating Param : \(paramRating)")
    }
    
    do {
        let bourbon = try findBourbon(name: name, rating: rating)
        let out = Bourbon()
        out.name = bourbon.name
        out.rating = bourbon.rating
        out.price = bourbon.price
        out.proof = bourbon.proof
        try response.setBody(json: out)
        response.completed()
    } catch {
        print(error)
        response.completed(status: .badRequest)
        
    }

    
})

routes.add(method: .post, uri: "/v1/bourbon/save", handler: {
    request, response in
    if let name = request.param(name: "name", defaultValue: ""),
        let price = request.param(name: "price",defaultValue: "0"),
        let proof = request.param(name: "proof", defaultValue: "0"),
        let rating = request.param(name: "rating",defaultValue: "0")
    {
        do {
            let _ = try saveNewBourbon(name: name, price: Double(price)!, proof: Double(proof)!, rating: Int(rating)!)
            response.setBody(string: "Success Saved")
            response.completed()
        } catch {
            print(error)
        }

    } else {
        print("The parameter is missing")
        response.completed(status: .badRequest)
    }



})

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
        let query = BSON(map: ["username":"Lucy"])
        let query2 = BSON(map: ["email":"lucy5@gmail.com"])
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

routes.add(method: .get, uri: "/v1/mongo/find/{name}", handler: {
    request, response in
    
    if let name = request.param(name: "name") {
        // perform a find
        do {
            let _ = try findByString(name: name)
        } catch {
            print("Error in findByString: \(error)")
        }
        response.completed()
    } else {
        response.completed(status: .badRequest)
    }
    
    
})

routes.add(method: .post, uri: "/v1/mongo/save/{name}", handler: {
    request, response in
    
    let name = request.param(name: "name")
    
    // Standard Save
    do {
        let _ = try saveNew(name: name!)
    } catch {
        print("1. \(error)")
    }
    response.completed()
})



struct Filter1: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        // You can do stuff here just as middleware does
        print("Filter1 excuted")
        callback(HTTPRequestFilterResult.continue(request, response))
    }
}

struct Filter2: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        // You can do stuff here jsut as middlware does
        print("Filter2 excuted")
        callback(.execute(request, response))
    }
}

struct Filter3: HTTPResponseFilter {
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        //
        callback(.continue)
    }
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        //
        callback(.done)
    }
}

struct Filter4: HTTPResponseFilter {
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.done)
    }
}

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
    (Filter1(), HTTPFilterPriority.high),
    (Filter2(), HTTPFilterPriority.medium)
]

let responseFilters: [(HTTPResponseFilter, HTTPFilterPriority)] = [
    (Filter3(), HTTPFilterPriority.high),
    (Filter4(), HTTPFilterPriority.medium)
]

server.setRequestFilters(requestFilters)

server.setResponseFilters(responseFilters)

server.addRoutes(routes)

server.documentRoot = "./webroot"

server.serverPort = 3000

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg){
  print("Network error thrown: \(err) \(msg) ")
}
