//
//  GetEventByIdResponseModel.swift
//
//  Created by user on 22.01.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation

class GetHeaderResponseModel: BaseResponseModel {
    var id: String?
    var created: String?
    var updated: String?
    var deleted: String?
    var title: String?
    var lastActivity: String?
    var archived: String?
    var properties: Properties?
    var items: [AnyCodable]?
    var members: [Member]?
    
    
    var totalCount: Int?
    
    enum GetSnapsCodingKeys: String, CodingKey {
        case id = "id"
        case created = "created"
        case updated = "updated"
        case deleted = "deleted"
        case title = "title"
        case lastActivity = "last_activity"
        case archived = "archived"
        case properties = "properties"
        case items = "items"
        case members = "members"

    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: GetSnapsCodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        id = try? decoderContainer.decode(String.self, forKey: .id)
        created = try? decoderContainer.decode(String.self, forKey: .created)
        updated = try? decoderContainer.decode(String.self, forKey: .updated)
        deleted = try? decoderContainer.decode(String.self, forKey: .deleted)
        title = try? decoderContainer.decode(String.self, forKey: .title)
        lastActivity = try? decoderContainer.decode(String.self, forKey: .lastActivity)
        archived = try? decoderContainer.decode(String.self, forKey: .archived)
        properties = try? decoderContainer.decode(Properties.self, forKey: .properties)
        members = try? decoderContainer.decode([Member].self, forKey: .members)
        items = try? decoderContainer.decode([AnyCodable].self, forKey: .items)
    }
    
}


class Member: BaseResponseModel {
    var id: String?
    var created: String?
    var updated: String?
    var deleted: String?
    var tableId: String?
    var userId: String?
    var message: String?
    var accepted: Bool?
     var crewMemberId: String?
     var lastVisit: String?
     var isOwner: Bool?
    var items: [AnyObject]?
    var members: String?
    
    
    var totalCount: Int?
    
    enum GetSnapsCodingKeys: String, CodingKey {
        case id = "id"
        case created = "created"
        case updated = "updated"
        case deleted = "deleted"
        case tableId = "table_id"
        case userId = "user_id"
        case message = "message"
        case accepted = "accepted"
        case crewMemberId = "crew_member_id"
        case lastVisit = "last_visit"
        case isOwner = "is_owner"

    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: GetSnapsCodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
        id = try? decoderContainer.decode(String.self, forKey: .id)
        created = try? decoderContainer.decode(String.self, forKey: .created)
        updated = try? decoderContainer.decode(String.self, forKey: .updated)
        deleted = try? decoderContainer.decode(String.self, forKey: .deleted)
        tableId = try? decoderContainer.decode(String.self, forKey: .tableId)
        userId = try? decoderContainer.decode(String.self, forKey: .userId)
        message = try? decoderContainer.decode(String.self, forKey: .message)
        accepted = try? decoderContainer.decode(Bool.self, forKey: .accepted)
        crewMemberId = try? decoderContainer.decode(String.self, forKey: .crewMemberId)
        lastVisit = try? decoderContainer.decode(String.self, forKey: .lastVisit)
        isOwner = try? decoderContainer.decode(Bool.self, forKey: .isOwner)
    }
    
}

class Properties: BaseResponseModel {
  
    var listId: String?

    enum GetSnapsCodingKeys: String, CodingKey {
        case listId = "list_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try? decoder.container(keyedBy: GetSnapsCodingKeys.self)
        guard let decoderContainer = container else {
            return
        }
        
     
        listId = try? decoderContainer.decode(String.self, forKey: .listId)
    }
}


public class AnyCodable: Any, Codable {
  
}
