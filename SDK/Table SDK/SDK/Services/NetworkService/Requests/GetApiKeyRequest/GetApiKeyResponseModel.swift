//
//  GetEventByIdResponseModel.swift
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class ApiKeyResponseModel: BaseResponseModel {
  
    var opentokApiKey: Int?

    enum ApikeyCodingKeys: String, CodingKey {
        case opentokApiKey = "opentok_api_key"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: ApikeyCodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
     
        opentokApiKey = try? decoderContainer.decode(Int.self, forKey: .opentokApiKey)
    }
}
