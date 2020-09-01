//
//  LoginUserRequestModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class NotificationTokenRequestModel: BaseRequestModel {
    var parameters: Data?
    
    override func createRequest() -> BaseRequest {
        return NotificationTokenRequest(with: self)
    }
}

class NotificationTokenParamsModel: Codable {
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "contact_apns_device_token"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
    }
}

