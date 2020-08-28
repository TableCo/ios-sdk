//
//  TableNetworkModel.swift
//  Table SDK
//
//  Created by user on 21.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

class TableNetworkModel {
    
    private var authRequest: RequestHelper<AuthUserRequestModel, AuthUserResponseModel>?
    private var authRequestModel = AuthUserRequestModel()
    
    var onAuthSuccess: ((_ user: AuthUserModel?) -> Void)?
    var onAuthFailed: ((_ error: Error?) -> Void)?
    
    
    private var tokenRequest: RequestHelper<NotificationTokenRequestModel, BaseResponseModel>?
    private var tokenRequestModel = NotificationTokenRequestModel()
    
    var onTokenSuccess: (() -> Void)?
    var onTokenFailed: ((_ error: Error?) -> Void)?
    
    init() {
        setupAuthPart()
        setupTokenPart()
    }
    
    //Auth
    private func setupAuthPart() {
        authRequest = RequestHelper(with: authRequestModel)
        authRequest?.loadingCallback = { [weak self] (response) in
            let user = response?.user
            self?.onAuthSuccess?(user)
            
        }
        authRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.onAuthFailed?(error)
        }
    }
    
    func tryToAuthUser(userParamsModel: UserParamsModel) {
        do {
            let encodedData = try JSONEncoder().encode(userParamsModel)
            authRequestModel.parameters = encodedData
            authRequest?.fetch()
        } catch {
            onAuthFailed?(nil)
        }
        
    }
    
    //Token
    
    private func setupTokenPart() {
        tokenRequest = RequestHelper(with: tokenRequestModel)
        tokenRequest?.loadingCallback = { [weak self] (response) in
            
            self?.onTokenSuccess?()
            
        }
        tokenRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.onTokenFailed?(error)
        }
    }
    
    func tryToSendToken(token: String) {
        do {
            let tokenModel = NotificationTokenParamsModel()
            tokenModel.token = token
            let encodedData = try JSONEncoder().encode(tokenModel)
            authRequestModel.parameters = encodedData
            authRequest?.fetch()
        } catch {
            onTokenFailed?(nil)
        }
    }
    
}
