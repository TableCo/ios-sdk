//
//  LoginUserRequest.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class CreateConversationRequest: BaseRequest {
    static let path = API.CreateConversation
    
    init(with model: CreateConversationRequestModel) {
        super.init()
        
        self.path.append(CreateConversationRequest.path)
        self.method = .post
        self.headersType = .formData
        self.parametersType = .encodeParametersType
        
        self.data = model.parameters
    }
}
