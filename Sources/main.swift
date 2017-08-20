import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MongoDB


let server = HTTPServer()

var routes = Routes()

routes.add(method: .get, uri: "/hello", handler: {
    request, response in
    // Setting the response content type explicitly to text/html
    response.setHeader(.contentType, value: "text/html")
    // Adding some HTML to the response body object
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    // Signalling that the request is completed
    response.completed()
})

routes.add(method: .get, uri: "/api/v1/horse", handler: {
    request, response in
    
    response.completed()
})

func returnJSONMessage(message: String, response: HTTPResponse) {
    do {
        try response.setBody(json: ["message": message])
        .setHeader(.contentType, value: "application/json")
        .completed()
    } catch {
        response.setBody(string: "Error Handling Request: \(error)")
            .completed(status: .internalServerError)
        
    }
}

routes.add(method: .get, uri: "/api/v1/getHorses", handler: {
    request, response in
    returnJSONMessage(message: "Hi", response: response)
})

routes.add(method: .get, uri: "/api/v1/{horse_name}") {
    (request, response) in
    guard let horseName = request.urlVariables["horse_name"] else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: horseName, response: response)
    response.completed()
}

routes.add(method: .post, uri: "/api/v1/horse") {
    (request, response) in
    guard let name = request.param(name: "name") else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: name, response: response)
}

routes.add(method: .get, uri: "api/v1/bourbon", handler: {
    request, response in
    

})

routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setHeader(.contentType, value: "text/html")
  response.appendBody(string: "<html>Website</html>")
  response.completed()
})

routes.add(method: .post, uri: "/api/v1/horse") {
    request, response in

    response.completed()

}

routes.add(method: .get, uri: "/v1") { (req, res) in
    res.appendBody(string: "Hi this is the v1 route")
    res.setBody(string: "This is the body of the v1 get method")
    res.completed()
}

routes.add(method: .get, uri: "/v1/v2/{bourbon}") { (req, res) in
    //res.setBody(string: "Variables are following \(String(describing: req.urlVariables["bourbon"])) is the best one \n")
    //res.appendBody(string: "The path is: \(req.path) \n")
    //http://localhost:8181/v1/?bourbon=jimbeam&?bourbon=woodford
    res.appendBody(string: "All the variables \(req.queryParams)")
    res.completed()
}

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

server.serverPort = 8181

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg){
  print("Network error thrown: \(err) \(msg) ")
}
