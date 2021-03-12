//
//  BookViewModelTests.swift
//  BestSellersTests
//
//  Created by Michael Kiley on 3/10/21.
//

import XCTest
@testable import BestSellers

class BookViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testBookViewModelEquality(){
        let book1 = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        let bookViewModel1 = BookViewModel(book: book1, bookService: MockBookService())
        let book2 = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        let bookViewModel2 = BookViewModel(book: book2, bookService: MockBookService())
        XCTAssertEqual(bookViewModel1, bookViewModel2)
        var hasher1 = Hasher.init()
        bookViewModel1.hash(into: &hasher1)
        var hasher2 = Hasher.init()
        bookViewModel1.hash(into: &hasher2)
        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
        
        //Same book but with longer weeksOnList
        let book3 = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 2)
        let bookViewModel3 = BookViewModel(book: book3, bookService: MockBookService())
        XCTAssertEqual(bookViewModel1, bookViewModel3)
        XCTAssertEqual(bookViewModel3.hashValue, bookViewModel3.hashValue)
    }
    
    func testBookViewModelInequality(){
        let book = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        let book2 = Book(title: "Michael's Sequal", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        let bookViewModel1 = BookViewModel(book: book, bookService: MockBookService())
        let bookViewModel2 = BookViewModel(book: book2, bookService: MockBookService())
        XCTAssertNotEqual(bookViewModel1, bookViewModel2)
        XCTAssertNotEqual(bookViewModel1.hashValue, bookViewModel2.hashValue)
    }
    
    func testGetAuthor(){
        let book1 = Book(title: "", author: "Michael Kiley", description: "", imageUrl: "", isbn10: "", weeksOnList: 1)
        let bookVM1 = BookViewModel(book: book1, bookService: MockBookService())
        XCTAssertEqual(bookVM1.getAuthor(), "By: Michael Kiley")
        
        let book2 = Book(title: "", author: "Michael Kiley.", description: "", imageUrl: "", isbn10: "", weeksOnList: 1)
        let bookVM2 = BookViewModel(book: book2, bookService: MockBookService())
        XCTAssertEqual(bookVM2.getAuthor(), "By: Michael Kiley")
    }
    
    func testGetTitle(){
        let book = Book(title: "MY TITLE", author: "", description: "", imageUrl: "", isbn10: "", weeksOnList: 1)
        let bookVM = BookViewModel(book: book, bookService: MockBookService())
        XCTAssertEqual(bookVM.getTitle(), "My Title")
    }
    
    func testLoadImageData() {
        
        
        class CoverImageMockBookService : BookService {
            
            var lastImageUrlString : String!
            var loadImageCalls : Int = 0
            
            func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
                completion([])
            }
            func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
                completion(nil)
            }
            func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
                loadImageCalls += 1
                lastImageUrlString = imageUrlString
                completion(Data(base64Encoded: "test")!)
            }
        }
        
        let coverImageService = CoverImageMockBookService()
        
        let book1 = Book(title: "", author: "", description: "", imageUrl: "test image url", isbn10: "", weeksOnList: 1)
        let bookVM1 = BookViewModel(book: book1, bookService: coverImageService)
        
        // book view model retries image data from web location on first request
        bookVM1.loadCoverImage { data in
            XCTAssertEqual(data, Data(base64Encoded: "test")!)
        }
        XCTAssertEqual(1, coverImageService.loadImageCalls)
        XCTAssertEqual("test image url", coverImageService.lastImageUrlString)
        
        // book view model returns local data on subsequent requests, not making another call to service
        bookVM1.loadCoverImage { data in
            XCTAssertEqual(data, Data(base64Encoded: "test")!)
        }
        XCTAssertEqual(1, coverImageService.loadImageCalls)
        XCTAssertEqual("test image url", coverImageService.lastImageUrlString)
    }


}
