//
//  BookViewModel.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation
import UIKit

class BookViewModel {
    
    private let bookService : BookService
    
    private let book : Book
    private var imageData : Data?
    private let id = UUID()
    
    init(book : Book, bookService: BookService){
        self.book = book
        self.bookService = bookService
    }
    
}

extension BookViewModel {
    func getTitle() -> String {
        return book.title.capitalized
    }
    
    func getAuthor() -> String {
        var authorString = "By: \(book.author)"
        if(authorString.last == "."){
            authorString.removeLast()
        }
        return authorString
    }
    
    func getDescription() -> String {
        return book.description
    }
    
    func getImageUrl() -> String? {
        return book.imageUrl
    }
    
    func loadCoverImage( completion : @escaping (Data) ->()){
        
        if let data = imageData {
            completion(data)
            return
        }
        
        if let urlString = book.imageUrl {
            bookService.loadImageData(imageUrlString: urlString) { [weak self] data in
                self?.imageData = data
                completion(data)
            }
        }
            
    }
}

extension BookViewModel : Hashable {
    
    static func == (lhs: BookViewModel, rhs: BookViewModel) -> Bool {
        return lhs.book.title == rhs.book.title && lhs.book.author == rhs.book.author
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(book.title)
        hasher.combine(book.author)
    }
    
}
