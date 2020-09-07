//
//  PagingUrlHelper.swift
//
//  Created by user on 2/18/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class PagingUrlHelper<R: BaseUrlPagingRequestModel, S: BaseResponsePagingUrlModel> {
    var previousUrl: String?
    var nextUrl: String?
    var currentUrl: URL?
    private var requestModel: R
    private var isLoading = false
    
    var loadingCallback: ((_ responseModel: S?) -> Void)?
    var errorCallback: (( _ error: Error?) -> Void)?
    
    init(with requestModel: R) {
        self.requestModel = requestModel
    }
    
    func fetch() {
        if isLoading  {
            return
        }
        
        isLoading = true
        
        NetworkManager.instance.dataTask(requestModel: requestModel, successBlock: { [weak self] (response: S?) in
            self?.previousUrl = response?.previous
            self?.nextUrl = response?.next
            (self?.nextUrl != nil) ? (self?.requestModel.isNextExist = true) : (self?.requestModel.isNextExist = false)
            self?.isLoading = false
            self?.loadingCallback?(response)
        }) { [weak self] (error) in
            self?.isLoading = false
            self?.errorCallback?(error)
        }
    }
    
    func forceFetch() {
        
        NetworkManager.instance.dataTask(requestModel: requestModel, successBlock: { [weak self] (response: S?) in
            self?.previousUrl = response?.previous
            self?.nextUrl = response?.next
            self?.loadingCallback?(response)
        }) { [weak self] (error) in
            self?.errorCallback?(error)
        }
    }
    
    
    // //"http://192.168.2.55/api/events/search/?q=t&limit=10&offset=10"
    func fetchNext() {
        if isLoading  {
            return
        }
        
        guard let nextStr = nextUrl, let next = URL(string: nextStr) else {
            self.errorCallback?(PagingUrlHelper.noContentError())
            return
        }
        requestModel.currentUrl = next
        
        requestModel.parameters = requestModel.currentUrl?.queryParameters ?? [:]
        guard requestModel.parameters.count > 0 else {
            return
        }
        isLoading = true
        
        NetworkManager.instance.dataTask(requestModel: requestModel, successBlock: { [weak self] (response: S?) in
            self?.previousUrl = response?.previous
            self?.nextUrl = response?.next
            (self?.nextUrl != nil) ? (self?.requestModel.isNextExist = true) : (self?.requestModel.isNextExist = false)
            self?.isLoading = false
            self?.loadingCallback?(response)
        }) { [weak self] (error) in
            self?.isLoading = false
            self?.errorCallback?(error)
        }
    }
    
    func forceFetchNext() {
        
        if let nextStr = nextUrl, let next = URL(string: nextStr) {
            requestModel.currentUrl = next
            requestModel.parameters = requestModel.currentUrl?.queryParameters ?? [:]
            
            guard requestModel.parameters.count > 0 else {
                return
            }
            
            NetworkManager.instance.dataTask(requestModel: requestModel, successBlock: { [weak self] (response: S?) in
                self?.previousUrl = response?.previous
                self?.nextUrl = response?.next
                self?.isLoading = false
                self?.loadingCallback?(response)
            }) { [weak self] (error) in
                self?.isLoading = false
                self?.errorCallback?(error)
            }
        }
    }
    
    
    static func noContentError() -> Error {
           let err = NSError(domain: "com.prism.noConternError", code: 208, userInfo: [NSLocalizedDescriptionKey: "Nothing to load. Pagination url is nil"])
           return err as Error
       }
}
