import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import StORM
import MongoDBStORM


let server = HTTPServer()

var routes = Routes()

MongoDBConnection.host = "localhost"
MongoDBConnection.database = "mydb"
MongoDBConnection.port = 27017

JSONDecoding.registerJSONDecodable(name: Bourbon.registerName, creator: { return Bourbon() })


routes.add(method: .get, uri: "/", handler: {
    request, response in
 
    response.setHeader(.contentType, value: "text/html")
  
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")

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
            bourbon.imageUrl = b.imageUrl
            bourbon.taste = b.taste
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
        let rating = request.param(name: "rating"),
        let taste = request.param(name: "taste"),
        let imageUrl = request.param(name: "imageUrl")
    {
        do {
            if (try isBourbonExist(name: name)) {
                try response.setBody(json: ["Error":"Bourbon Name already exist"])
                response.completed()
            } else {
                //let _ = try rating.validate()
                //let _ = try price.validate()
                //let _ = try proof.validate()
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
            //let _ = try price.validate()
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

routes.add(method: .post, uri: "/v1/bourbon/update/taste", handler: {
    request, response in
    if let name = request.param(name: "name"),
        let taste = request.param(name: "taste"),
        let imageUrl = request.param(name:"imageUrl"){
        do {
            try updateBourbonTaste(name: name, taste: taste, imageUrl: imageUrl)
            response.completed()
        } catch {
            print(error)
            response.completed(status: .badRequest)
        }
    } else {
        response.completed(status: HTTPResponseStatus.custom(code: 400, message: "Parameter Error"))
        }


})

routes.add(method: .post, uri: "/v1/bourbon/delete", handler: {
    request, response in
    
    if let name = request.param(name: "name") {
        do {
            try deleteObjectByName(name: name)
            response.completed()
        } catch {
            response.completed(status: .badRequest)
        }
        
    } else {
        response.completed(status: .badRequest)
    }

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
        // Before the response send to the client, you can do some stuff here
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

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = {
    let filters: [(HTTPRequestFilter, HTTPFilterPriority)] =
        [
            (Filter1(), HTTPFilterPriority.low),
            (Filter2(), HTTPFilterPriority.low)
            
        ]
    return filters
}()

let responseFilters: [(HTTPResponseFilter, HTTPFilterPriority)] = {
    let filters: [(HTTPResponseFilter, HTTPFilterPriority)] =
        [
            (Filter3(), HTTPFilterPriority.high),
            (Filter4(), HTTPFilterPriority.medium),
        ]
    return filters
}()

server.setRequestFilters(requestFilters)

server.setResponseFilters(responseFilters)

server.addRoutes(routes)

server.serverPort = 8181

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg){
  print("Network error thrown: \(err) \(msg) ")
}
