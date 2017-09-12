import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MongoDB
import MongoDBStORM
import MySQLStORM
import PerfectSession
import PerfectSessionMySQL

let server = HTTPServer()

var routes = Routes()

MongoDBConnection.host = "localhost"
MongoDBConnection.database = "mydb"
MongoDBConnection.port = 27017

MySQLConnector.host = "127.0.0.1"
MySQLConnector.database = "mydb"
MySQLConnector.username = "sean7218"
MySQLConnector.password = "123"
MySQLConnector.port = 3306


SessionConfig.name = "loginSesson"
SessionConfig.idle = 86400
SessionConfig.cookieDomain = "localhost"
SessionConfig.IPAddressLock = true
SessionConfig.userAgentLock = true
SessionConfig.purgeInterval = 3600


MySQLSessionConnector.host = "localhost"
MySQLSessionConnector.port = 3306
MySQLSessionConnector.username = "sean7218"
MySQLSessionConnector.password = "123"
MySQLSessionConnector.database = "mydb"
MySQLSessionConnector.table = "sessions"



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
    if let filename = request.urlVariables[routeTrailingWildcardKey] {
        request.path = filename
    } else {
        request.path = ""
    }
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

routes.add(method: .get, uri: "/v1/bourbon/getAll/", handler: {
    request, response in
    var out = [Bourbon]()
    do {
        let obj = BourbonORM()
        try obj.find()
        for b in obj.rows() {
            let bourbon = Bourbon()
            bourbon.name = b.name
            bourbon.price = b.price
            bourbon.proof = b.proof
            bourbon.rating = b.rating
            out.append(bourbon)
        }
        try response.setBody(json: out)
        response.completed()
    } catch {
        print(error)
        response.completed(status: .badRequest)
    }

})

routes.add(method: .get, uri: "/v1/bourbon/{name}", handler: {
    request, response in
    if let name = request.param(name: "name")
    {
        do {
            if (try isBourbonExist(name: name)) {
                let bourbon = try findBourbon(name: name, rating: nil)
                let out = Bourbon()
                out.name = bourbon.name
                out.rating = bourbon.rating
                out.price = bourbon.price
                out.proof = bourbon.proof
                try response.setBody(json: out)
                response.completed()
            } else {
                try response.setBody(json: ["error": "object doesn't exist"])
                response.completed()
            }
        } catch {
            response.status = HTTPResponseStatus.custom(code: 400, message: "Error: \(error)")
            response.completed()
        }
    } else {
        response.status = HTTPResponseStatus.custom(code: 400, message: "Missing Parameter")
        response.completed()
    }
})

routes.add(method: .post, uri: "/v1/bourbon/save", handler: {
    request, response in
    if let name = request.param(name: "name"),
        let price = request.param(name: "price"),
        let proof = request.param(name: "proof"),
        let rating = request.param(name: "rating")
    {
        do {
            if (try isBourbonExist(name: name)) {
                try response.setBody(json: ["Error":"Bourbon Name already exist"])
                response.completed()
            } else {
                let _ = try rating.validate()
                let _ = try price.validate()
                let _ = try proof.validate()
                let _ = try saveNewBourbon(name: name,
                                           price: Double(price)!,
                                           proof: Double(proof)!,
                                           rating: Int(rating)!)
                response.setBody(string: "Saving Sucess")
                response.completed()
            }
        } catch {
            response.status = HTTPResponseStatus.custom(code: 400, message: "Error: \(error.localizedDescription)")
            response.completed()
        }
    } else {
        response.status = HTTPResponseStatus.custom(code: 400, message: "Parameter Error")
        response.completed()
    }
})

routes.add(method: .post, uri: "/v1/bourbon/update", handler: {
    request, response in
    if let name = request.param(name: "name") {
        do {
            guard let price = request.param(name: "price") else { throw ServerError.missingUpdateParameter }
            let _ = try price.validate()
            let _ = try updateBourbon(name: name, price: Double(price)!)
            response.setBody(string: "Updated the bourbon")
            response.completed()

        } catch {
            response.status = HTTPResponseStatus.custom(code: 400, message: "Error: \(error)")
            response.completed()
        }
    } else {
        response.status = HTTPResponseStatus.custom(code: 400, message: "Parameter Error")
        response.completed()
    }
})


routes.add(method: .get, uri: "/v2/race", handler: {
    request, response in
    
    do {
        try findAllRaces()
        response.completed()
    } catch {
        print(error)
        response.completed(status: .badRequest)
    }

})

routes.add(method: .get, uri: "/v2/race/{name}", handler: {
    request, response in
    if let name = request.param(name: "name") {
        do {
            let _ = try findRace(name: name)
            response.completed()
        } catch {
            response.status = HTTPResponseStatus.custom(code: 400, message: "Error: \(error)")
            response.completed()
        }

    } else {
        response.status = HTTPResponseStatus.custom(code: 400, message: "Bad Request: No Name Parameter")
        response.completed()
    }
    

})

routes.add(method: .get, uri: "/v2/session/test", handler: {
    request, response in
    
    let rand = UUID()
    request.session?.data["UUID-1"] = rand.string
    
    var data = ""
    do {
        data = try request.session?.data.jsonEncodedString() ?? ""
    } catch {
        print(error)
    }
    var body = "<p>Your Session ID is: <code>\(String(describing: request.session?.token))</code></p>"
    body += "<p>Your Session State is: <code>\(String(describing: request.session?._state))</code></p>"
    body += "<p>Your Session Data is: <code>\(data)))</p></code>"
    body += "<p>Your IP Address is: <code>\(String(describing: request.session?.ipaddress))</p></code>"
    response.setBody(string: body)
    response.completed()

})

let sessionDriver = SessionMySQLDriver()

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

struct Filter5: HTTPRequestFilter {
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        //
        print("Filter Session Request")
        sessionDriver.requestFilter.0.filter(request: request, response: response, callback: callback)
    }
}

struct Filter6: HTTPResponseFilter {
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        //
        print("Filter Session Response Headers")
        sessionDriver.responseFilter.0.filterHeaders(response: response, callback: callback)
    }
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        //
        print("Filter Session Response Body")
        sessionDriver.responseFilter.0.filterBody(response: response, callback: callback)
    }
}

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = {
    let filters: [(HTTPRequestFilter, HTTPFilterPriority)] =
        [
            (Filter1(), HTTPFilterPriority.high),
            (Filter2(), HTTPFilterPriority.medium),
            (Filter5(), sessionDriver.requestFilter.1)
        ]
    return filters
}()

let responseFilters: [(HTTPResponseFilter, HTTPFilterPriority)] = {
    let filters: [(HTTPResponseFilter, HTTPFilterPriority)] =
        [
            (Filter3(), HTTPFilterPriority.high),
            (Filter4(), HTTPFilterPriority.medium),
            (Filter6(), sessionDriver.responseFilter.1)
        ]
    return filters
}()

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
