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

func addRoutes(){
    var routes = Routes()
    routes.add(method: .get, uri: "mongo/v1/get", handler: {
        request, response in
        do {
            try response.setBody(json: ["Mongo Connection": "Starting Page"])

        } catch let err {
            print(err)
        }

    })
    
}
