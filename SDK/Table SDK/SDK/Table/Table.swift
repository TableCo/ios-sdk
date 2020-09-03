//
//  Table.swift
//  Table SDK
//
//  Created by user on 17.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

public final class Table {
    private var tableData: TableData
    private var isDefaultLauncher: Bool
    private var networkModel = TableNetworkModel()
    var isAuthentificated: Bool {
        get {
            guard tableData.userID != nil, tableData.token != nil else {
                return false
            }
            return true
        }
    }
    
    static let instance = Table()
    
    private init() {
        tableData = TableData()
        isDefaultLauncher = false
    }
}

//MARK: -Public interface
extension Table {
    
    public static func initialize(workspaceUrl: String, apiKey: String, experienceShortCode: String? = nil, onSuccessInitializeCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
       
        Table.instance.tableData.experienceShortCode = experienceShortCode
        
        if let validWorkspace = Table.instance.validWorkspaceURL(workspaceUrl) {
            Table.instance.tableData.workspaceUrl = validWorkspace
      
        } else {
            onFailureCompletion?(Message.ErrorMessages.noWorkspaceAdded.code, Message.ErrorMessages.noWorkspaceAdded.message)
            return
        }
        
        if !apiKey.isEmpty {
            Table.instance.tableData.apiKey = apiKey
        } else {
            onFailureCompletion?(Message.ErrorMessages.apiKeyEmpty.code, Message.ErrorMessages.apiKeyEmpty.message)
            return
        }
        
        print("Workspace: \(workspaceUrl) Key: \(apiKey)")
        
        Table.instance.tableData.updateNotificationTokenCompletion = {(token) in
            guard let token = token else { return }
            
            Table.instance.sendNotificationToken(token: token, onSuccessTokenCompletion: {
                print("Notifiction token sended")
            }) { (code, errorMessage) in
                print("Notification token error:\(String(describing: code)), ErrorMessage: \(String(describing: errorMessage))")
            }
        }
        
        onSuccessInitializeCompletion?()
    }
    
    public static func registerUser(withUserId userID: String, userAttributes: UserAttributes, onSuccessLoginCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        Table.instance.tableData.userAttributes = userAttributes
        
      
        
        if !userID.isEmpty {
           Table.instance.tableData.userID = userID
        } else {
            onFailureCompletion?(Message.ErrorMessages.userIdEmpty.code, Message.ErrorMessages.userIdEmpty.message)
            return
        }
        
        Table.instance.registerUser(onSuccessLoginCompletion: {
            onSuccessLoginCompletion?()
        }) { (code, message) in
            onFailureCompletion?(code, message)
        }
    }
    
    public static func registerUnidentifiedUser(onSuccessLoginCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        Table.instance.registerUser(onSuccessLoginCompletion: {
            onSuccessLoginCompletion?()
        }) { (code, message) in
            onFailureCompletion?(code, message)
        }
    }
    
    public static func logout() {
        Table.instance.tableData.userID = nil
        Table.instance.tableData.token = nil
        NetworkManager.instance.authToken = ""
    }
    
    public static func showConversationList(parentViewController: UIViewController, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        guard Table.instance.isAuthentificated else {
            onFailureCompletion?(Message.ErrorMessages.userIdEmpty.code, Message.ErrorMessages.userIdEmpty.message)
            return
        }
        
        let navVC = UINavigationController()
        navVC.modalPresentationStyle = .fullScreen
        let vc = ConversationVC.instantiateFromAppStoryBoard(appStoryBorad: .TableMainBoard)
        navVC.viewControllers = [vc]
        parentViewController.present(navVC, animated: true)
    }
    
    public static func updateNotificationToken(token: String) {
        Table.instance.tableData.notificationToken = token
    }
}

//MARK: -Private methods
private extension Table {
    func registerUser(onSuccessLoginCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        let paramsModel = UserParamsModel()
        paramsModel.updateFromTableData(Table.instance.tableData)
        
        guard Table.instance.validWorkspaceURL(Table.instance.getWorkspaceUrl()) != nil else {
            onFailureCompletion?(Message.ErrorMessages.noWorkspaceAdded.code, Message.ErrorMessages.noWorkspaceAdded.message)
            return
        }
        
        guard !Table.instance.tableData.apiKey.isEmpty else {
            onFailureCompletion?(Message.ErrorMessages.apiKeyEmpty.code, Message.ErrorMessages.apiKeyEmpty.message)
            return
        }
        
        
        Table.instance.networkModel.tryToAuthUser(userParamsModel: paramsModel)
        
        Table.instance.networkModel.onAuthSuccess = { (user) in
            NetworkManager.instance.authToken = user?.token ?? ""
                       onSuccessLoginCompletion?()
            
            Table.instance.tableData.userID = user?.id
            Table.instance.tableData.token = user?.token
           
        }
        
        Table.instance.networkModel.onAuthFailed = { (error) in
            guard let error = error as NSError? else {
                onFailureCompletion?(nil, nil)
                return
            }
            
            print(error.localizedDescription)
            
            let code = error.code
            
            if code >= 400, code < 500 {
                onFailureCompletion?(Message.ErrorMessages.networkFailure.code, Message.ErrorMessages.networkFailure.message)
            } else if code >= 500 {
                onFailureCompletion?(Message.ErrorMessages.general.code, "Inconsistent data during registration")
            }
        }
    }
    
    func sendNotificationToken(token: String, onSuccessTokenCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        
        Table.instance.networkModel.tryToSendToken(token: token)
        
        Table.instance.networkModel.onTokenSuccess = {
            onSuccessTokenCompletion?()
        }
        
        Table.instance.networkModel.onTokenFailed = { (error) in
            guard let error = error as NSError? else {
                onFailureCompletion?(nil, nil)
                return
            }
            onFailureCompletion?(error.code, error.description)
        }
    }
    
    func validWorkspaceURL(_ workspaceUrl: String)-> String? {
           var validWorkspaceUrl = workspaceUrl
        
           guard !validWorkspaceUrl.isEmpty else { return nil }
           
           // Make sure we're on https protocol identifier
           if !validWorkspaceUrl.contains("http") {
               validWorkspaceUrl = "https://" + validWorkspaceUrl
           }
            
           // If the developer used just their table ID then add the standard table domain
           if (!validWorkspaceUrl.contains(".")) {
               validWorkspaceUrl = validWorkspaceUrl + ".table.co"
           }
           
           // Don't want double trailing slashes
           if (validWorkspaceUrl.hasSuffix("//")) {
               validWorkspaceUrl = String(validWorkspaceUrl.dropLast())
           }
           
           // Make sure we never end with the trailing slash
           if (validWorkspaceUrl.hasSuffix("/")) {
               validWorkspaceUrl = String(validWorkspaceUrl.dropLast())
           }
           
           guard let _ = URL(string: workspaceUrl) else {
               return nil
           }
           
           return validWorkspaceUrl
       }
}

//MARK: -Internal methods
extension Table {
    func getWorkspaceUrl() -> String {
           return Table.instance.tableData.workspaceUrl
       }
    
       func getToken() -> String? {
           return Table.instance.tableData.token
       }
       
       func getUserExperienceShortCode()->String? {
           return Table.instance.tableData.experienceShortCode
       }
}
    
