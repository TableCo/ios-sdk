//
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class GetApiKeyRequest: BaseRequest {
    static var path = API.OpenTokAPIKey
    
    init(with model: GetApiKeyRequestModel) {
        super.init()
        
        self.path.append(GetApiKeyRequest.path)


        self.method = .get
        self.headersType = .base
        self.parametersType = .postRequestWithQuery
        self.parameters = model.parameters
    }
}
