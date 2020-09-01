//
//  LoginUserRequest.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class NotificationTokenRequest: BaseRequest {
    static let path = API.NotificationTokenUpdate
    
    init(with model: NotificationTokenRequestModel) {
        super.init()
        
        self.path.append(NotificationTokenRequest.path)
        self.method = .post
        self.headersType = .withJSON
        self.parametersType = .encodeParametersType
        
        self.data = model.parameters
    }
}
