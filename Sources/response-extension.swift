import PerfectHTTP
import PerfectHTTPServer
import PerfectLib


JSONDecoding.registerJSONDecodable(name: Horse.registerName, creator: { return Horse() })
JSONDecoding.registerJSONDecodable(name: Bourbon.registerName, creator: { return Bourbon() })
JSONDecoding.registerJSONDecodable(name: User.registerName, creator: { return User() })

class Horse: JSONConvertibleObject {

    static let registerName = "horse"

    var name = ""
    var earning = ""
    var speed = 0
    
    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.earning = getJSONValue(named: "earning", from: values, defaultValue: "")
        self.speed = getJSONValue(named: "speed", from: values, defaultValue: "")
    }

    override func getJSONValues() -> [String : Any] {
        return [
            JSONEncoding.objectIdentifierKey: Horse.registerName,
            "name": self.name,
            "earning": self.earning,
            "speed": self.speed
        ]
    }

}

class Bourbon: JSONConvertibleObject {

    static let registerName = "bourbon"

    var name = ""
    var price = 0
    var proof = 0
    var rating = 0
    var taste = ""
    var imageUrl = ""

    override func setJSONValues(_ values: [String : Any]) {
        self.name = getJSONValue(named: "name", from: values, defaultValue: "")
        self.price = getJSONValue(named: "price", from: values, defaultValue: 0)
        self.proof = getJSONValue(named: "proof", from: values, defaultValue: 0)
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

class User: JSONConvertibleObject {
    
    static let registerName = "user"

    var id = ""
    var name = ""
    var imageUrl = ""
    var luck = 0

    override func setJSONValues(_ values: [String : Any]) {
        self.id = getJSONValue(named: "id", from: values,  defaultValue: "")
        self.name = getJSONValue(named: "name", from: values, defaultValue:"")
        self.imageUrl = getJSONValue(named: "imageUrl", from: values,  defaultValue: "")
        self.luck = getJSONValue(named: "luck", from: values,  defaultValue: 0)
    }

    override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: User.registerName,
            "id": self.id,
            "name": self.name,
            "imageUrl": self.imageUrl,
            "luck": self.luck
        ]
    }
}

let server = HTTPServer();

server.documentRoot = "./webroot"

let routes = Routes();

// The following example establishes a virtual documents path, 
// serving all URIs which begin with "/files" from the physical directory "/var/www/htdocs":
routes.add(method: .get, uri: "/api/**", handler: {
    HTTPRequest, HTTPResponse in 
    
    // get the portion of the request path wich was matched by the wildcard
    request.path = request.urlVariables[routeTrailingWildCardKey]

    // Initialize the static file handler
    let handler = StaticFileHandler(documentRoot: "/var/www/htdocs")

    handler.handleRequet(request: request, response: response)
    
})

class Handlers {
    static func JSONtestGET(data: [String: Any]) throws -> RequestHandler {
        return {
            request, response in 
            do {
                try response.setBody(json: ["message": "Hello World!, This is json request"])
            } catch {
                print(error)
            }
            response.completed()
        }
    }

    static func JSONtestPOST(data: [String: Any]) throws -> RequestHandler {
        return {
            request, response in 
            do {
                if let name = request.param(name: "name") {
                    try response.setBody(json: ["message":"Hello, \(name)!"])
                } else {
                    try response.setBody(json: ["message":"Hello, I can personalize this if you let me?"])
                }
            } catch {
                print(error)
            }
            response.completed()
        }
    }

    static func JSONtestPOSTbody(data: [String: Any]) throws -> RequestHandler {
        return {
            request, response in 
            do {
                if let body = request.postBodyString {
                    let json = try body.jsonDecode() as? [String: Any]
                    let name = json["name"] as? String ?? "Undefined"
                    try reponse.setBody(json: ["message": "Hello, \(name)!"])
                } else {
                    try response.setBody(json: ["message": "Hello, I can personalize this if you let me?"])
                }
            } catch pattern {
                print(error)
            }
            response.completed()
        }
    }
}