//
//  Common.swift
//  TestTable
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

struct Message {
    
    struct Permission {
        static let cameraAccess      = "You have not granted access to use camera."
        static let micAccess         = "You have not allowed microphone permission."
        static let cameraSetting     = "Camera access is required for video call."
        
    }
    
    struct ErrorMessages {
        
        static let noWorkspaceAdded: ErrorMessage = ErrorMessage(code: 101, message: "No workspace URL supplied")
        static let apiKeyEmpty: ErrorMessage = ErrorMessage(code: 103, message: "No API key supplied")
        static let userIdEmpty: ErrorMessage = ErrorMessage(code: 104, message: "User ID not supplied")
        static let firstNameEmpty: ErrorMessage = ErrorMessage(code: 105, message: "First name field is empty")
        static let lastNameEmpty: ErrorMessage = ErrorMessage(code: 106, message: "Last name field is empty")
        static let emailEmpty: ErrorMessage = ErrorMessage(code: 107, message: "Email address field is empty")
        static let networkFailure: ErrorMessage = ErrorMessage(code: 108, message: "Network error")
        static let alreadyRegistered: ErrorMessage = ErrorMessage(code: 109, message: "User is already registered")
        static let general: ErrorMessage = ErrorMessage(code: 10, message: "General error")
    }
    
    struct ErrorMessage {
        let code: Int
        let message: String
        
        init(code: Int, message: String) {
            self.code = code
            self.message = message
        }
    }

}

