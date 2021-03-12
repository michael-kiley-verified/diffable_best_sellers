//
//  NYTBookServiceTests.swift
//  BestSellersTests
//
//  Created by Michael Kiley on 3/12/21.
//

import XCTest
import UIKit
@testable import BestSellers
    
class MockURLProtocol: URLProtocol {
    
    static var dataToSend: Data = Data()
    static var notifyUrlRecieved : (URL?)->() = { url in return }
    
    override func startLoading() {
        //Notify any testers with the url we have recieved
        MockURLProtocol.notifyUrlRecieved(request.url)
        //Notify client that response was recieved
        let mockResponse = HTTPURLResponse(url: request.url!, mimeType: "", expectedContentLength: 0, textEncodingName: "")
        client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
        //Send data to client
        client?.urlProtocol(self, didLoad: MockURLProtocol.dataToSend)
        //Notify client that response is finished
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
}

class NYTBookServiceTests: XCTestCase {
    
    //Reset MockURL customization before each test
    override func setUp() {
        MockURLProtocol.dataToSend = Data()
        MockURLProtocol.notifyUrlRecieved = { url in return }
    }
    //Clean up MockURL customization after all tests have run
    override static func tearDown() {
        MockURLProtocol.dataToSend = Data()
        MockURLProtocol.notifyUrlRecieved = { url in return }
    }

    func testLoadListSummaries() {
        
        // Set up url listener and expectation
        let expectation1 = XCTestExpectation()
        let expectedUrl = "https://api.nytimes.com/svc/books/v3/lists/overview.json?api-key=\(UIApplication.nytAPIKey)"
        func urlListener(url : URL?){
            XCTAssertNotNil(url)
            XCTAssertEqual(url!.absoluteString, expectedUrl)
            expectation1.fulfill()
        }
        MockURLProtocol.notifyUrlRecieved = urlListener
  
        // Set up data response callback and expectation
        let expectation2 = XCTestExpectation()
        let bestSellerList = BestSellerList(id: "1", books: [], name: "My List", displayName: "My List", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        MockURLProtocol.dataToSend = try! JSONEncoder().encode(SummaryResultsDto(results: SummaryResultsDto.ListsDto(lists: [bestSellerList])))
        func dataCompletion(lists : [BestSellerList]?){
            XCTAssertNotNil(lists)
            XCTAssertEqual(lists!, [BestSellerList(id: "1", books: [], name: "My List", displayName: "My List", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)])
            expectation2.fulfill()
        }
        
        // Use MockURLProtocol to set up NYTBookService and call loadListSummaries
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: sessionConfig)
        let nytService = NYTBookService(session: urlSession)
        nytService.loadListSummaries(completion: dataCompletion)
        
        
        wait(for: [expectation1, expectation2], timeout: 5)
        
        
    }
    
    func testLoadList() {
        
        // Set up url listener and expectation
        let expectation1 = XCTestExpectation()
        let expectedUrl = "https://api.nytimes.com/svc/books/v3/lists/TEST_TIME/TEST_ID.json?api-key=\(UIApplication.nytAPIKey)"
        func urlListener(url : URL?){
            XCTAssertNotNil(url)
            XCTAssertEqual(url!.absoluteString, expectedUrl)
            expectation1.fulfill()
        }
        MockURLProtocol.notifyUrlRecieved = urlListener
  
        // Set up data response callback and expectation
        let expectation2 = XCTestExpectation()
        let bestSellerList = BestSellerList(id: "1", books: [], name: "My List", displayName: "My List", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY)
        MockURLProtocol.dataToSend = try! JSONEncoder().encode(ListResultsDto(results: bestSellerList))
        func dataCompletion(list : BestSellerList?){
            XCTAssertNotNil(list)
            XCTAssertEqual(list!, BestSellerList(id: "1", books: [], name: "My List", displayName: "My List", previouslyPublishedString: "", nextPublishedString: "", frequency: .WEEKLY))
            expectation2.fulfill()
        }
        
        // Use MockURLProtocol to set up NYTBookService and call loadList
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: sessionConfig)
        let nytService = NYTBookService(session: urlSession)
        nytService.loadList(id: "TEST_ID", timeString: "TEST_TIME", completion: dataCompletion)
        
        
        wait(for: [expectation1, expectation2], timeout: 5)
        
        
    }
    
    func testLoadImage() {
        
        // Set up url listener and expectation
        let expectation1 = XCTestExpectation()
        let expectedUrl = "https://google.com"
        func urlListener(url : URL?){
            XCTAssertNotNil(url)
            XCTAssertEqual(url!.absoluteString, expectedUrl)
            expectation1.fulfill()
        }
        MockURLProtocol.notifyUrlRecieved = urlListener
  
        // Set up data response callback and expectation
        let expectation2 = XCTestExpectation()
        MockURLProtocol.dataToSend = Data(base64Encoded: "test")!
        func dataCompletion(data : Data){
            XCTAssertEqual(data, Data(base64Encoded: "test"))
            expectation2.fulfill()
        }
        
        // Use MockURLProtocol to set up NYTBookService and call loadImage
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: sessionConfig)
        let nytService = NYTBookService(session: urlSession)
        nytService.loadImageData(imageUrlString: "https://google.com", completion: dataCompletion)
        
        
        wait(for: [expectation1, expectation2], timeout: 5)
        
       
        
    }


}


