import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()

var routes = Routes()

routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setHeader(.contentType, value: "text/html")
  response.appendBody(string: "<html>Website</html>")
  response.completed()
})

routes.add(method: .get, uri: "/v1") { (req, res) in
    res.appendBody(string: "Hi this is the v1 route")
    res.setBody(string: "This is the body of the v1 get method")
    res.completed()
}

routes.add(method: .get, uri: "/v1/{bourbon}") { (req, res) in
    //res.setBody(string: "Variables are following \(String(describing: req.urlVariables["bourbon"])) is the best one \n")
    //res.appendBody(string: "The path is: \(req.path) \n")
    //http://localhost:8181/v1/?bourbon=jimbeam&?bourbon=woodford
    res.appendBody(string: "All the variables \(req.queryParams)")
    res.completed()
}

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

server.serverPort = 8181

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg){
  print("Network error thrown: \(err) \(msg) ")
}
