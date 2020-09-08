//
//  GetEventByIdRequestModel.swift
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class GetHeaderRequestModel: BaseUrlPagingRequestModel {
    var tableId = ""
    
    override func createRequest() -> BaseRequest {
        return GetHeaderRequest(with: self)
    }
}
