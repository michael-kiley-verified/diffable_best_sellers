//
//  Book.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation
import UIKit

struct Book : Codable, Hashable {
    
    let title : String
    let author : String
    let description : String
    let imageUrl : String?
    let isbn10 : String
    let weeksOnList : Int
    
    
    private enum CodingKeys : String, CodingKey {
        case title, author, description, imageUrl = "book_image", isbn10 = "primary_isbn10", weeksOnList = "weeks_on_list"
    }
}
