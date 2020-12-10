//
//  File.swift
//  Pods-TableSample
//
//  Created by Afify on 26/11/2020.
//


import Foundation

class GetTableRequestModel: BaseRequestModel {
    var parameters: Data?
    
    override func createRequest() -> BaseRequest {
        return GetTableRequest(with: self)
    }
}

class GetTableParamsModel: Codable {
    var experienceShortCode: String?

    enum CodingKeys: String, CodingKey {
        case experienceShortCode = "experience_short_code" 
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(experienceShortCode, forKey: .experienceShortCode)
    }
}

