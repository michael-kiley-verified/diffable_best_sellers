//
//  NYTBookService.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation

protocol BookService {
    func loadListSummaries(completion : @escaping ([BestSellerList]?) -> ())
    func loadList(id : String, timeString: String, completion : @escaping (BestSellerList?) -> ())
    func loadImageData(imageUrlString : String, completion: @escaping (Data) -> ())
}

struct SummaryResultsDto : Codable {
    
    struct ListsDto : Codable {
        var lists : [BestSellerList]
    }
    
    var results : ListsDto
}

struct ListResultsDto : Codable {
    var results : BestSellerList
}



// A mocked BookService implementation using sample api data files for use in development
struct MockBookService : BookService {
    
    func loadListSummaries(completion : @escaping ([BestSellerList]?) -> ()){
        
        if let url = Bundle.main.url(forResource: "mockSummaries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(SummaryResultsDto.self, from: data)
                completion(jsonData.results.lists);
                return
            } catch {
                print("error:\(error)")
            }
        }
        
       
    }
    
    func loadList(id : String, timeString: String, completion : @escaping (BestSellerList?) -> ()){
        
        if let url = Bundle.main.url(forResource: "mockCombinedFictionList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ListResultsDto.self, from: data)
                completion(jsonData.results);
                return
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
        if let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("ERROR fetching image from url: \(error)")
                    return
                }
                guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
                    print("Caught http error")
                    return
                }
                if let data = data {
                    completion(data)
                }
            
            }.resume()
        }
    }
    
}


