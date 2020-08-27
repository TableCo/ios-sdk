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

init() {
    setupAuthPart()
}

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
}
