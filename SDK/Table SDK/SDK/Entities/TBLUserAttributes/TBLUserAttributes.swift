//
//  TBLUserAttributes.swift
//  Table SDK
//
//  Created by user on 20.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

public struct UserAttributes {
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var userHash: String?
    
    public var customAttributes: [String: AnyCodable]?
    
    public init() {}
}
