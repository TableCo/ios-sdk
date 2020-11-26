//
//  GetTableResponse.swift
//  Pods-TableSample
//
//  Created by Afify on 26/11/2020.
//

import Foundation

class GetTableResponseModel: BaseResponseModel {
    var tableId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case tableId = "id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        tableId = try? decoderContainer.decode(String.self, forKey: .tableId)
    }
}
