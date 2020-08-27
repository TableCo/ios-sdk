//
//  LoginUserRequest.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class AuthUserRequest: BaseRequest {
    static let path = API.AuthUser
    
    init(with model: AuthUserRequestModel) {
        super.init()
        
        self.path.append(AuthUserRequest.path)
        self.method = .post
        self.headersType = .withJSON
        self.parametersType = .encodeParametersType
        
        self.data = model.parameters
    }
}
