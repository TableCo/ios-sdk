//
//  VideoViewModel.swift
//  TestTable
//
//  Created by user on 26.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

class VideoViewModel {
    
    //get header
    private var getOpenTokenRequest: RequestHelper<GetApiKeyRequestModel, ApiKeyResponseModel>?
    private var getOpenTokenRequestModel = GetApiKeyRequestModel()
    var getOpenTokenSuccess: ((_ apiKey: String?) -> Void)?
    var getOpenTokenFailed: ((_ error: Error?) -> Void)?
    
    
    
    init() {
        setupOpenTokenPart()
    }
    
    //get conversation title
    private func setupOpenTokenPart() {
        getOpenTokenRequest = RequestHelper(with: getOpenTokenRequestModel)
        getOpenTokenRequest?.loadingCallback = { [weak self] (response) in
            guard let apiKeyInt = response?.opentokApiKey else {
                self?.getOpenTokenFailed?(nil)
                return
            }
            let apiKeyString = String(apiKeyInt)
            self?.getOpenTokenSuccess?(apiKeyString)
        }
        
        getOpenTokenRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.getOpenTokenFailed?(error)
        }
    }
    
    func getOpenTokKey() {
        getOpenTokenRequest?.fetch()
    }
    
}

