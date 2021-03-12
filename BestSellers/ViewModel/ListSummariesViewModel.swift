//
//  ListSummariesViewModel.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation

class ListSummariesViewModel {
    
    private let bookService : BookService
    weak var delegate : ViewModelObservor?
    
    private var bestSellerLists : [BestSellerList] = [] {
        didSet {
            delegate?.didUpdateViewModel()
        }
    }
    
    var listViewModels : [BestSellerListViewModel]{
        bestSellerLists.map{
            BestSellerListViewModel(list: $0, bookService: bookService)
        }
    }
    
    init(bookService : BookService){
        self.bookService = bookService
    }
    
}

extension ListSummariesViewModel {
    
    func loadListSummaries(){
        bookService.loadListSummaries { [weak self] (loadedBestSellerLists) in
            if let lists = loadedBestSellerLists {
                self?.bestSellerLists = lists
            }
        }
    }
    
    
}

protocol ViewModelObservor : AnyObject {
    func didUpdateViewModel()
}


