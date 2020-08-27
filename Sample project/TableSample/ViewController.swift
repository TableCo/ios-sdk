//
//  ViewController.swift
//  TableSample
//
//  Created by user on 20.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit
import Table_SDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Table.initialize(workspaceUrl: "https://***REMOVED***", apiKey: "978fQmN5ReV3vPKclQgHEg", onSuccessInitializeCompletion: {
            
        }) { (errorCode, message) in
            
        }
        
    }

    @IBAction func registerUser(_ sender: Any) {
        var userAttrib = UserAttributes()
        userAttrib.firstName = "Test"
        userAttrib.lastName = "User"
        Table.registerUser(withUserId: "d1cc6bb2-6266-4497-aa0e-63ec35c07908", userAttributes: userAttrib, onSuccessLoginCompletion: {
            
        }) { (errorCode, errorMessage) in
            print()
        }
    }
    
    @IBAction func registerAnonimous(_ sender: Any) {
        Table.registerUnidentifiedUser(onSuccessLoginCompletion: {
            
        }) { (errorCode, errorMessage) in
            
        }
    }
    
    @IBAction func showConversationList(_ sender: Any) {
        Table.showConversationList(parentViewController: self) { (errorCode, errorMessage) in
            
        }
    }
    
    @IBAction func Logout(_ sender: Any) {
        Table.logout()
    }
}


