//
//  BestSellerList.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation

struct BestSellerList : Codable, Hashable {
    
    let id : String
    let books : [Book]
    let name : String
    let displayName : String
    let previouslyPublishedString : String?
    let nextPublishedString : String?
    let frequency : ListFrequency?
    
    private enum CodingKeys : String, CodingKey {
        case id = "list_name_encoded", books, name = "list_name", displayName = "display_name", previouslyPublishedString = "previous_published_date", nextPublishedString = "next_published_date", frequency = "updated"
    }
    
}

enum ListFrequency : String, Codable {
    case WEEKLY
    case MONTHLY
}
