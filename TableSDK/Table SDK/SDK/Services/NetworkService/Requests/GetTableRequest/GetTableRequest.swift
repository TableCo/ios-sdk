//
//  GetTableRequest.swift
//  Table SDK
//
//  Created by Afify on 26/11/2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

class GetTableRequest: BaseRequest {
    static let path = API.GetTable
    
    init(with model: GetTableRequestModel) {
        super.init()
        
        self.path.append(GetTableRequest.path)
        self.method = .post
        self.headersType = .formData
        self.parametersType = .encodeParametersType
        
        self.data = model.parameters
    }
}
