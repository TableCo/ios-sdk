//
//  LoginUserResponseModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class AuthUserResponseModel: BaseResponseModel {
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

class AuthUserModel: BaseResponseModel {
    var token: String? = ""
    var isAgent: String? = ""
    var id: String? = ""
    var message: String? = ""
    var workspace: String? = ""
    var experienceShortCode: String? = ""
    var fcmNotificationChannel: String? = ""
    var jpushNotificationChannel: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case isAgent = "is_agent"
        case id = "id"
        case message = "message"
        case workspace = "workspace"
        case experienceShortCode = "experience_short_code"
        case fcmNotificationChannel = "fcm_notification_channel"
        case jpushNotificationChannel = "jpush_notification_channel"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        token = try? decoderContainer.decode(String.self, forKey: .token)
        isAgent = try? decoderContainer.decode(String.self, forKey: .isAgent)
        id = try? decoderContainer.decode(String.self, forKey: .id)
        message = try? decoderContainer.decode(String.self, forKey: .message)
        workspace = try? decoderContainer.decode(String.self, forKey: .workspace)
        experienceShortCode = try? decoderContainer.decode(String.self, forKey: .experienceShortCode)
        fcmNotificationChannel = try? decoderContainer.decode(String.self, forKey: .fcmNotificationChannel)
        jpushNotificationChannel = try? decoderContainer.decode(String.self, forKey: .jpushNotificationChannel)
    }
}
