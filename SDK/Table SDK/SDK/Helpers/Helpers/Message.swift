//
//  Common.swift
//  TestTable
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

struct Message {
    
    struct Validation {
        static let workspace        = "Please enter workspace"
        static let emailInValid     = "Please enter a valid email address"
        static let email            = "Please enter an email address"
        static let password         = "Please enter a password"
    }
    
    struct APIResponse {
        static let register         = "Registered Successfully"
        static let login            = "Login Success"
        static let forgotPassowrd   = "Password sent to your email address successfully"
        static let invalidWorkspace = "Please enter valid workspace"
        static let couldntGetClientId = "Unable to get Google Client ID"
    }
    
    struct Network {
        static let somethingWentWrong      = "Something went wrong. Please try again later"
        static let noInternet              = "No Internet Connection Available"
    }
    
    struct Permission {
        static let cameraAccess      = "You have not granted access to use camera."
        static let micAccess         = "You have not allowed microphone permission."
        static let cameraSetting     = "Camera access is required for video call."
        
    }
    

}

