//
//  Endpoints.swift
//  TestTable
//
//  Created by user on 22.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

struct API {
    static let Login                = "/user-service/user/signin"
    static let User                 = "/user-service/user"
    static let GoogleLogn           = "/user-service/user/google_signin"
    static let Conversation         = "/conversation?webview=ios"
    
    
    static let NotificationTokenUpdate  = "/user-service/user/add_contact_apns_device_token"
    static let ConversationTitle        = "/table-service/table/"
    static let GoogleClientId           = "/installation-service/installation/google-client-id"
    static let InstalationProperties    = "/installation-service/installation/properties"
    static let AuthUser                 = "/user-service/user/auth/sdk-chat-user"
    static let CreateConversation       = "/table-service/table"
    static let AddJpushRegistrationId   = "/user-service/user/add_contact_jpush_device_token"
    static let GetTable                 = "/table-service/table-for-experience"
    static let Loading                  = "/static/mobile-progress.html"
}
