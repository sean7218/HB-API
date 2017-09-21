//
//  Utils.swift
//  HBApi
//
//  Created by Sean Zhang on 9/20/17.
//
//

import Foundation
extension String {
    func validate() throws -> Bool {
        if Double(self) != nil {
            return true
        } else if Int(self) != nil {
            return true
        } else {
            throw ValidationError.incorrectType
        }
    }
}
