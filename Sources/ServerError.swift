//
//  ServerError.swift
//  HBApi
//
//  Created by Sean Zhang on 9/6/17.
//
//

import Foundation

enum ServerError: Error {
    case incorrectParameter
    case objectNotExist
    case parameterTypeError
    case missingUpdateParameter
}
