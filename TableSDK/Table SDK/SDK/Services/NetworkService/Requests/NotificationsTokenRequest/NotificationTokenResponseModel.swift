//
//  LoginUserResponseModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class NotificationTokenResponseModel: BaseResponseModel {
    var user: AuthUserModel?
    
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        user = try? decoderContainer.decode(AuthUserModel.self, forKey: .user)
    }
}
