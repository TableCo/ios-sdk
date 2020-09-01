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
            
        }) { [weak self] (errorCode, errorMessage) in
            self?.showError(errorCode: errorCode, errorMessage: errorMessage)
        }
        
    }

    @IBAction func registerUser(_ sender: Any) {
        var userAttrib = UserAttributes()
        userAttrib.firstName = "Bruice"
        userAttrib.lastName = "User"
        userAttrib.email = "bruice@gmail.com"
        Table.registerUser(withUserId: "1212313214Bruice", userAttributes: userAttrib, onSuccessLoginCompletion: { [userAttrib, weak self] in
            self?.showAlert(nil, message: "You are logined as \(userAttrib.firstName ?? "") \(userAttrib.lastName ?? "")")
        }) { [weak self](errorCode, errorMessage) in
            self?.showError(errorCode: errorCode, errorMessage: errorMessage)
        }
    }
    
    @IBAction func registerAnonimous(_ sender: Any) {
        Table.registerUnidentifiedUser(onSuccessLoginCompletion: {[weak self] in
            self?.showAlert(nil, message: "You are logined as Anonimous user")
        }) { [weak self] (errorCode, errorMessage) in
            self?.showError(errorCode: errorCode, errorMessage: errorMessage)
        }
    }
    
    @IBAction func showConversationList(_ sender: Any) {
        Table.showConversationList(parentViewController: self) { [weak self] (errorCode, errorMessage) in
            self?.showError(errorCode: errorCode, errorMessage: errorMessage)
        }
    }
    
    @IBAction func Logout(_ sender: Any) {
        Table.logout()
    }
    
    func showError(errorCode: Int?, errorMessage: String?) {
        guard let codeInt = errorCode else {
            showAlert("Error", message: errorMessage ?? "")
            return
        }
        showAlert("Error", message: "Code: \(String(codeInt))  \(errorMessage ?? "")")
    }
}


