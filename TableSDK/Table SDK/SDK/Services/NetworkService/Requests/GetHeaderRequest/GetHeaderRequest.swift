//
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class GetHeaderRequest: BaseRequest {
    static var path = API.ConversationTitle
    
    init(with model: GetHeaderRequestModel) {
        super.init()
        
        self.path.append(GetHeaderRequest.path)
        self.path.append(model.tableId)

        self.method = .get
        self.headersType = .base
        self.parametersType = .postRequestWithQuery
        self.parameters = model.parameters
    }
}
