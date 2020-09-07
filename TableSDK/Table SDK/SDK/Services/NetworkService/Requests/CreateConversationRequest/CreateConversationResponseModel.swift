//
//  LoginUserResponseModel.swift
//  Prism
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class CreateConversationResponseModel: BaseResponseModel {
    var conversationId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        conversationId = try? decoderContainer.decode(String.self, forKey: .conversationId)
    }
}
