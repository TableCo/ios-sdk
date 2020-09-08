//
//  ViewController.swift
//  TableSample
//
//  Created by user on 20.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit
import TableSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        Table.initialize(workspaceUrl: "https://develop4.dev.table.co", apiKey: "test_key", onSuccessInitializeCompletion: {
            print("Table has been initialized")
        }) { (errorCode, errorMessage) in
            print("\(String(describing: errorCode)): \(String(describing: errorMessage))")
        }
        
    }

    @IBAction func registerUser(_ sender: Any) {
        var userAttrib = UserAttributes()
        userAttrib.firstName = "Test"
        userAttrib.lastName = "User"
        userAttrib.email = "test@testmail.com"
        Table.registerUser(withUserId: "test_user_id_1", userAttributes: userAttrib, onSuccessLoginCompletion: { [userAttrib, weak self] in
            self?.showAlert(nil, message: "You are logged in as \(userAttrib.firstName ?? "") \(userAttrib.lastName ?? "")")
        }) { [weak self](errorCode, errorMessage) in
            self?.showError(errorCode: errorCode, errorMessage: errorMessage)
        }
    }
    
    @IBAction func registerAnonimous(_ sender: Any) {
        Table.registerUnidentifiedUser(onSuccessLoginCompletion: {[weak self] in
            self?.showAlert(nil, message: "You are logged in as an Anonymous user")
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


