//
//  Routes.swift
//  HBApi
//
//  Created by Sean Zhang on 8/18/17.
//
//

import PerfectHTTP

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
    
    return routes
}
