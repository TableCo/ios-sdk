//
//  GetEventByIdRequestModel.swift
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class GetApiKeyRequestModel: BaseUrlPagingRequestModel {
    
    override func createRequest() -> BaseRequest {
        return GetApiKeyRequest(with: self)
    }
}
