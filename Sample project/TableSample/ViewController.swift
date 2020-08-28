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
        userAttrib.email = "ambrazhnik@gmail.com"
        Table.registerUser(withUserId: "1212313214", userAttributes: userAttrib, onSuccessLoginCompletion: { [userAttrib, weak self] in
            self?.showAlert(nil, message: "You are logined as \(userAttrib.firstName ?? "") \(userAttrib.lastName ?? "")")
        }) { [weak self](errorCode, errorMessage) in
            guard let codeInt = errorCode else {
                self?.showAlert("Error", message: errorMessage ?? "")
                return
            }
            self?.showAlert("Error", message: "Code: \(String(codeInt))  \(errorMessage ?? "")")
        }
    }
    
    @IBAction func registerAnonimous(_ sender: Any) {
        Table.registerUnidentifiedUser(onSuccessLoginCompletion: {[weak self] in
            self?.showAlert(nil, message: "You are logined as Anonimous user")
        }) { [weak self] (errorCode, errorMessage) in
             guard let codeInt = errorCode else {
                 self?.showAlert("Error", message: errorMessage ?? "")
                 return
             }
             self?.showAlert("Error", message: "Code: \(String(codeInt))  \(errorMessage ?? "")")
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


