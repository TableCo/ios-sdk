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
    
    public static func initialize(workspaceUrl: String, apiKey: String, experienceShortCode: String? = nil, fcmNotificationChannel: String? = nil, jpushNotificationChannel: String? = nil, onSuccessInitializeCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        print("Workspace: \(workspaceUrl) Key: \(apiKey)")
        Table.instance.tableData.apiKey = apiKey
        Table.instance.tableData.workspaceUrl = workspaceUrl
        Table.instance.tableData.experienceShortCode = experienceShortCode
        Table.instance.tableData.fcmNotificationChannel = fcmNotificationChannel
        Table.instance.tableData.jpushNotificationChannel = jpushNotificationChannel
    }
    
    public static func registerUser(withUserId userID: String, userAttributes: UserAttributes, onSuccessLoginCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        Table.instance.tableData.userAttributes = userAttributes
        Table.instance.tableData.userID = userID
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
    
    public static func updateUser(_ attributes: UserAttributes) {
           
    }
    
    public static func logout() {
        Table.instance.tableData.userID = nil
        Table.instance.tableData.token = nil
        NetworkManager.instance.authToken = ""
    }
    
    public static func showConversationList(parentViewController: UIViewController, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        guard Table.instance.isAuthentificated else {
            onFailureCompletion?(104, "User ID is Empty")
            return
        }
        
        let navVC = UINavigationController()
        let vc = ConversationVC.instantiateFromAppStoryBoard(appStoryBorad: .TableMainBoard)
        navVC.viewControllers = [vc]
        parentViewController.present(navVC, animated: true)
    }
}

//MARK: -Private methods
private extension Table {
    func registerUser(onSuccessLoginCompletion: (() -> Void)?, onFailureCompletion: ((_ errorCode: Int?, _ details: String?) -> Void)?) {
        let paramsModel = UserParamsModel()
        paramsModel.updateFromTableData(Table.instance.tableData)
        Table.instance.networkModel.tryToAuthUser(userParamsModel: paramsModel)
        
        Table.instance.networkModel.onAuthSuccess = { (user) in
            
            Table.instance.tableData.token = user?.token
            Table.instance.tableData.userID = user?.id
            NetworkManager.instance.authToken = user?.token ?? ""
            onSuccessLoginCompletion?()
        }
        
        Table.instance.networkModel.onAuthFailed = { (error) in
            guard let error = error as NSError? else {
                onFailureCompletion?(nil, nil)
                return
            }
            onFailureCompletion?(error.code, error.description)
        }
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
    