//
//  ConversationViewModel.swift
//  TestTable
//
//  Created by user on 22.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//
import Foundation

class ConversationViewModel {
    
    //get header
    private var getHeaderRequest: RequestHelper<GetHeaderRequestModel, GetHeaderResponseModel>?
    private var getHeaderRequestModel = GetHeaderRequestModel()
    var getHeaderSuccess: ((_ header: GetHeaderResponseModel?) -> Void)?
    var getheaderFailed: ((_ error: Error?) -> Void)?
    
    //create conversation
    private var createConversationRequest: RequestHelper<CreateConversationRequestModel, CreateConversationResponseModel>?
    private var createConversationRequestModel = CreateConversationRequestModel()
    var createConversationSuccess: ((_ conversationId: String?) -> Void)?
    var createConversationFailed: ((_ error: Error?) -> Void)?
    
    //get table
    private var getTableRequest: RequestHelper<GetTableRequestModel, GetTableResponseModel>?
    private var getTableRequestModel = GetTableRequestModel()
    var getTableSuccess: ((_ tableId: String?) -> Void)?
    var getTableFailed: ((_ error: Error?) -> Void)?
    
    
    init() {
        setupGeatheaderPart()
        setupCreateConversationPart()
        setupGetTablePart()
    }
    
    //get conversation title
    private func setupGeatheaderPart() {
        getHeaderRequest = RequestHelper(with: getHeaderRequestModel)
        getHeaderRequest?.loadingCallback = { [weak self] (response) in
            let response = response
            self?.getHeaderSuccess?(response)
        }
        
        getHeaderRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.getheaderFailed?(error)
        }
    }
    
    func getConversationTitle(url: String, completion:@escaping (String?) -> Void) {
        guard let url = URL(string: url), let lastSegment = url.pathComponents.last else { return }
        
        if (url.path.contains("/conversation/") && lastSegment.count == 36) {
            getTitle(idStr: lastSegment)
            
            getHeaderSuccess = {(header) in
                completion(header?.title)
            }
            
            getheaderFailed = {(error) in
                completion(nil)
            }
        }
    }
    
    private func getTitle(idStr: String) {
        let url = API.ConversationTitle + idStr
        print(url)
        
        getHeaderRequestModel.tableId = idStr
        getHeaderRequest?.fetch()
    }
    
    //check login
    func checkLoggedIn(isLoggedIn: @escaping (Bool) -> Void) {
        isLoggedIn(Table.instance.isAuthentificated)
    }
    
    
    //create conversation
    private func setupCreateConversationPart() {
        createConversationRequest = RequestHelper(with: createConversationRequestModel)
        createConversationRequest?.loadingCallback = { [weak self] (response) in
            let id = response?.conversationId
            self?.createConversationSuccess?(id)
            
        }
        createConversationRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.createConversationFailed?(error)
        }
    }
    func tryCreateConversation(experienceShortCode: String?) {
        do {
            let paramsModel = CreateConversationParamsModel()
            paramsModel.experienceShortCode = experienceShortCode
            let encodedData = try JSONEncoder().encode(paramsModel)
            createConversationRequestModel.parameters = encodedData
            createConversationRequest?.fetch()
        } catch {
            createConversationFailed?(nil)
        }
        
    }
    //get table
    private func setupGetTablePart() {
        getTableRequest = RequestHelper(with: getTableRequestModel)
        getTableRequest?.loadingCallback = { [weak self] (response) in
            let id = response?.tableId
            self?.getTableSuccess?(id)
        }
        getTableRequest?.errorCallback = { [weak self] (error) in
            guard let error = error else {
                return
            }
            self?.getTableFailed?(error)
        }
    }
    func tryGetTable(experienceShortCode: String?) {
        do {
            let paramsModel = GetTableParamsModel()
            paramsModel.experienceShortCode = experienceShortCode
            let encodedData = try JSONEncoder().encode(paramsModel)
            getTableRequestModel.parameters = encodedData
            getTableRequest?.fetch()
        } catch {
            getTableFailed?(nil)
        }
    }
}
