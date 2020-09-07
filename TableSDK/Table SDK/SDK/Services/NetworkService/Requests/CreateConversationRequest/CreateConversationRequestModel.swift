//
//  LoginUserRequestModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class CreateConversationRequestModel: BaseRequestModel {
    var parameters: Data?
    
    override func createRequest() -> BaseRequest {
        return CreateConversationRequest(with: self)
    }
}

class CreateConversationParamsModel: Codable {
    var experienceShortCode: String?

    enum CodingKeys: String, CodingKey {
        case experienceShortCode = "experience_short_code"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(experienceShortCode, forKey: .experienceShortCode)
    }
}

