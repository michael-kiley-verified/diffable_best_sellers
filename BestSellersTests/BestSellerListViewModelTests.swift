//
//  BestSellerListViewModelTests.swift
//  BestSellersTests
//
//  Created by Michael Kiley on 3/10/21.
//

import XCTest
@testable import BestSellers

class BestSellerListViewModelTests: XCTestCase {
    

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Testing implementations of == and hash(into:) - important for diffable data source usage
    func testBestSellerListEqualityWithSameContents(){
        
        let book = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        
        let list1 = BestSellerList(id: "1", books: [book], name: "Michael's Best Sellers", displayName: "Michael's Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM1 = BestSellerListViewModel(list: list1, bookService: MockBookService())
        
        let list2 = BestSellerList(id: "1", books: [book], name: "Michael's Best Sellers", displayName: "Michael's Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM2 = BestSellerListViewModel(list: list2, bookService: MockBookService())
        
        XCTAssertEqual(listVM1, listVM2)
        var hasher1 = Hasher()
        listVM1.hash(into: &hasher1)
        var hasher2 = Hasher()
        listVM2.hash(into: &hasher2)
        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
    }
    
    func testBestSellerListEqualityWithDifferentContents(){
        let book = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        let book2 = Book(title: "Michael's Sequel", author: "Michael", description: "A sequel by Michael", imageUrl: "www.google.com", isbn10: "5678", weeksOnList: 1)
        
        let list1 = BestSellerList(id: "1", books: [book], name: "Michael's Best Sellers", displayName: "Michael's Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM1 = BestSellerListViewModel(list: list1, bookService: MockBookService())
        
        let list2 = BestSellerList(id: "1", books: [book2], name: "Michael's Best Sellers", displayName: "Michael's Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM2 = BestSellerListViewModel(list: list2, bookService: MockBookService())
        
        XCTAssertEqual(listVM1, listVM2)
        var hasher1 = Hasher()
        listVM1.hash(into: &hasher1)
        var hasher2 = Hasher()
        listVM2.hash(into: &hasher2)
        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
        
    }
    
    func testBestSellerListInequality(){
        let book = Book(title: "Michael's Book", author: "Michael", description: "A book by Michael", imageUrl: "www.google.com", isbn10: "1234", weeksOnList: 1)
        
        let list1 = BestSellerList(id: "1", books: [book], name: "Michael's Best Sellers", displayName: "Michael's Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM1 = BestSellerListViewModel(list: list1, bookService: MockBookService())
        
        let list2 = BestSellerList(id: "2", books: [book], name: "Michael's Other Best Sellers", displayName: "Michael's Other Best Sellers", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        let listVM2 = BestSellerListViewModel(list: list2, bookService: MockBookService())
        
        XCTAssertNotEqual(listVM1, listVM2)
        var hasher1 = Hasher()
        listVM1.hash(into: &hasher1)
        var hasher2 = Hasher()
        listVM2.hash(into: &hasher2)
        XCTAssertNotEqual(hasher1.finalize(), hasher2.finalize())
    }
    
    func testDateConversion(){
        //Date string format given by NYT api, and is equivalent in Swift date form
        let dateString = "2021-03-11"
        //Expected date in Swift form
        let expectedDate = Calendar.current.date(from: DateComponents(year: 2021, month: 03, day: 11))
        
        let convertedDate = BestSellerListViewModel.dateStringToDate(dateString: dateString)
        
        XCTAssertNotNil(convertedDate)
        XCTAssertEqual(convertedDate, expectedDate)
    }
    
    func testGetAgeStringWithWeeklyFrequency(){
        
        let list = BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "prev", nextPublishedString: "next", frequency: .WEEKLY)
        
        struct AgeMockBookService : BookService {
            func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
                completion([])
            }
            func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
                completion(BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "prev", nextPublishedString: "next", frequency: .WEEKLY))
            }
            func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
                completion(Data())
            }
        }
        
        let listVM = BestSellerListViewModel(list: list, bookService: AgeMockBookService())
        
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
        listVM.loadOlderList()
        XCTAssertEqual(listVM.getListAge(), "1 week old")
        
        listVM.loadOlderList()
        XCTAssertEqual(listVM.getListAge(), "2 weeks old")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "1 week old")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
    }
    
    func testGetAgeStringWithMonthlyFrequency(){
        
        let list = BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "prev", nextPublishedString: "next", frequency: .MONTHLY)
        
        struct AgeMockBookService : BookService {
            func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
                completion([])
            }
            func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
                completion(BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "prev", nextPublishedString: "next", frequency: .MONTHLY))
            }
            func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
                completion(Data())
            }
        }
        
        let listVM = BestSellerListViewModel(list: list, bookService: AgeMockBookService())
        
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
        listVM.loadOlderList()
        XCTAssertEqual(listVM.getListAge(), "1 month old")
        
        listVM.loadOlderList()
        XCTAssertEqual(listVM.getListAge(), "2 months old")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "1 month old")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
        listVM.loadNewerList()
        XCTAssertEqual(listVM.getListAge(), "Latest list")
        
    }
    
    func testLoadOlderList(){
        let list = BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "1st previously published", nextPublishedString: "", frequency: .MONTHLY)
        
        class TimeMockBookService : BookService {
            
            var lastTimeString : String!
            
            func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
                completion([])
            }
            func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
                lastTimeString = timeString
                completion(BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "2nd previously published", nextPublishedString: "", frequency: .MONTHLY))
            }
            func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
                completion(Data())
            }
        }
        
        let mockBookService = TimeMockBookService()
        let listViewModel = BestSellerListViewModel(list: list, bookService: mockBookService)
        
        listViewModel.loadOlderList()
        XCTAssertEqual(mockBookService.lastTimeString, "1st previously published")
        
        listViewModel.loadOlderList()
        XCTAssertEqual(mockBookService.lastTimeString, "2nd previously published")
        
    }
    
    func testLoadNewerList(){
        let list = BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "previously published", nextPublishedString: "", frequency: .MONTHLY)
        
        class TimeMockBookService : BookService {
            
            var lastTimeString : String!
            var loadListCallsCount : Int = 0
            
            func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
                completion([])
            }
            func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
                lastTimeString = timeString
                loadListCallsCount += 1
                completion(BestSellerList(id: "", books: [], name: "", displayName: "", previouslyPublishedString: "2nd previously published", nextPublishedString: "next published", frequency: .MONTHLY))
            }
            func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
                completion(Data())
            }
        }
        
        let mockBookService = TimeMockBookService()
        let listViewModel = BestSellerListViewModel(list: list, bookService: mockBookService)
        
        listViewModel.loadNewerList()
        XCTAssertEqual(mockBookService.loadListCallsCount, 0)
        
        listViewModel.loadOlderList()
        XCTAssertEqual(mockBookService.lastTimeString, "previously published")
        XCTAssertEqual(mockBookService.loadListCallsCount, 1)
        
        listViewModel.loadNewerList()
        XCTAssertEqual(mockBookService.lastTimeString, "next published")
        XCTAssertEqual(mockBookService.loadListCallsCount, 2)
        
    }
    


}


