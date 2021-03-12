//
//  NYTBookService.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/12/21.
//

import Foundation
import UIKit

struct NYTBookService : BookService {
    
    private let urlSession : URLSession!
    
    init(session : URLSession = URLSession.shared) {
        urlSession = session
    }
    
    func loadListSummaries(completion: @escaping ([BestSellerList]?) -> ()) {
        guard let url = URL(string: "https://api.nytimes.com/svc/books/v3/lists/overview.json?api-key=\(UIApplication.nytAPIKey)") else {
            return
        }
        let task = urlSession.dataTask(with: url){ data, response, error in
            if let error = error {
                print("caught error retrieving lists: \(error)")
                return
            }
            guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
                print("caught http error")
                return
            }
            if let data = data {
                do{
                    let decodedData = try JSONDecoder().decode(SummaryResultsDto.self, from: data)
                    completion(decodedData.results.lists)
                } catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func loadList(id: String, timeString: String, completion: @escaping (BestSellerList?) -> ()) {
        guard let url = URL(string: "https://api.nytimes.com/svc/books/v3/lists/\(timeString)/\(id).json?api-key=\(UIApplication.nytAPIKey)") else {
            return
        }
        let task = urlSession.dataTask(with: url){ data, response, error in
            if let error = error{
                print(error)
                return
            }
            guard let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode) else {
                print("http error")
                return
            }
            if let data = data {
                do{
                    let decodedData = try JSONDecoder().decode(ListResultsDto.self, from: data)
                    completion(decodedData.results)
                } catch {
                    print(error)
                }
                
            }
            
        }
        task.resume()
    }
    
    func loadImageData(imageUrlString: String, completion: @escaping (Data) -> ()) {
        if let url = URL(string: imageUrlString) {
            urlSession.dataTask(with: url) { data, response, error in
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

extension UIApplication {
    static var nytAPIKey : String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "NYT_API_KEY") as? String, key != "" else {
            fatalError("You must provide a valid New York Times Books API api key in order to run this app. You can get one here: https://developer.nytimes.com/")
        }
        return key
    }
}
