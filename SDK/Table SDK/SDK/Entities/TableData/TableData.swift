//
//  TableData.swift
//  Table SDK
//
//  Created by user on 20.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

class TableData {
    // Members which don't need to reset
    internal var workspaceUrl = ""
    internal var apiKey = ""
    internal var token: String?
    internal var experienceShortCode: String?
    internal var fcmNotificationChannel: String?
    internal var jpushNotificationChannel: String?
    internal var themeColor = UIColor.init(hexString: "#307AEB")
    internal var userAttributes = UserAttributes()

    // Members to reset on logout
    internal var userID: String?

}
