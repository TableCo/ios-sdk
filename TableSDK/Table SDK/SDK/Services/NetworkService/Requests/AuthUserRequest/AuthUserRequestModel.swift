//
//  LoginUserRequestModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class AuthUserRequestModel: BaseRequestModel {
    var parameters: Data?
    
    override func createRequest() -> BaseRequest {
        return AuthUserRequest(with: self)
    }
}

class UserParamsModel: Codable {
    var userId: String?
    var email: String?
    var apiKey: String?
    var userHash: String?
    var firstName: String?
    var lastName: String?
    var customAttributes: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case apiKey = "api_key"
        case userHash = "user_hash"
        case firstName = "first_name"
        case lastName = "last_name"
        case customAttributes = "custom_attributes"
    }
    
//    required init(from decoder: Decoder) throws {
//       
//        let container = try? decoder.container(keyedBy: CodingKeys.self)
//        guard let decoderContainer = container else {
//            return
//        }
//        
//     
//        userId = try? decoderContainer.decode(String.self, forKey: .userId)
//        email = try? decoderContainer.decode(String.self, forKey: .email)
//        apiKey = try? decoderContainer.decode(String.self, forKey: .apiKey)
//        userHash = try? decoderContainer.decode(String.self, forKey: .userHash)
//        firstName = try? decoderContainer.decode(String.self, forKey: .firstName)
//        lastName = try? decoderContainer.decode(String.self, forKey: .lastName)
//        customAttributes = try? decoderContainer.decode([String: AnyCodable].self, forKey: .customAttributes)
//    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(apiKey, forKey: .apiKey)
        try container.encode(userHash, forKey: .userHash)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(customAttributes, forKey: .customAttributes)
    }
    
    func updateFromTableData(_ tableData: TableData) {
        userId = tableData.userID
        email = tableData.userAttributes.email
        apiKey = tableData.apiKey
        userHash = tableData.userAttributes.userHash
        firstName = tableData.userAttributes.firstName
        lastName = tableData.userAttributes.lastName
        customAttributes = tableData.userAttributes.customAttributes
    }
}

