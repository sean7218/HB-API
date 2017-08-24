import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MongoDB


let server = HTTPServer()

var routes = Routes()

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


routes.add(method: .get, uri: "/v1/bourbon", handler: {
    request, response in
    
    let wdir = Dir("~/apps/HBApi/Sources/")
    let json = File(wdir.path + "bourbon.json")
    var result = ""
    do {
        result = try json.readString()
    } catch {
        print(error)
    }
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: result)
    response.completed()
    
})




routes.add(method: .get, uri: "/v1/horse", handler: {
    request, response in

    do {
        try response.setBody(json: ["JIM BEAM":"Fda"])
    } catch {
        print(error)
    }
    response.completed()

})

routes.add(method: .get, uri: "/v1/mongo", handler: { request, response in
    
    // Open a connection
    let client = try! MongoClient(uri: "mongodb://localhost:27017")
    
    // Set database, assuming HBApi exist
    let db = client.getDatabase(name: "mydb")
    
    // Define collection
    guard let collection = db.getCollection(name: "users") else {
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
    
})

routes.add(method: .get, uri: "/v1/mongo/{name}", handler: {
    request, response in
    let client = try! MongoClient(uri: "mongodb://localhost")
    let db = client.getDatabase(name: "mydb")
    let col = db.getCollection(name: "users")
    defer {
        col?.close()
        db.close()
        client.close()
    }
    let query = BSON()
    query.append(key: "email", string: "lucy1@gmail.com")
    
    let arr = col?.find(query: query)

    // define a returning file
    var json = [[String: Any]]()
    var users = [User]()
    for i in arr! {
        

        guard let user = try! i.asString.jsonDecode() as? User else {
            return
        }
        
        users.append(user)
        
        //let user = try! i.asString.jsonDecode() as! [String: Any]
        //json.append(user)
    }
    
    try! response.setBody(json: users)
    .completed()
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
