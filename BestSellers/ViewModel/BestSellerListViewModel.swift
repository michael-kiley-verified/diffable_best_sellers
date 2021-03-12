//
//  BestSellerListViewModel.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation

class BestSellerListViewModel {
    
    private let bookService : BookService
    
    weak var observorDelegate : ViewModelObservor?
    private var list : BestSellerList {
        didSet {
            observorDelegate?.didUpdateViewModel()
        }
    }
    
    var bookViewModels : [BookViewModel] {
        list.books.map{
            BookViewModel(book: $0, bookService: bookService)
        }
    }
    
    var listStepsBack : Int = 0
    
    init(list : BestSellerList, bookService: BookService){
        self.list = list
        self.bookService = bookService
    }
    
    static func dateStringToDate(dateString : String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
}

extension BestSellerListViewModel {
    func getFormattedName()->String{
        return list.name
    }
    
    func getListAge()-> String{
        let pluralUnitString = list.frequency == ListFrequency.WEEKLY ? "weeks" : "months"
        let singularUnitString = list.frequency == ListFrequency.WEEKLY ? "week" : "month"
        var ageString = ""
        switch listStepsBack {
        case 0:
            ageString = "Latest list"
        case 1:
            ageString = "\(listStepsBack) \(singularUnitString) old"
        case 2...:
            ageString = "\(listStepsBack) \(pluralUnitString) old"
        default:
            ageString = "Latest list"
        }
        
        return ageString
    }
}

extension BestSellerListViewModel {
    
    func loadFullList(){
        bookService.loadList(id: list.id, timeString: "current"){ [weak self] (loadedList) in
            if let list = loadedList {
                self?.list = list
            }
        }
    }
    
    func loadOlderList(){
        if let prevPub = list.previouslyPublishedString{
            bookService.loadList(id: list.id, timeString: prevPub){ [weak self] (loadedList) in
                if let list = loadedList {
                    self?.listStepsBack += 1
                    self?.list = list
                }
            }
        }
        
    }
    
    func loadNewerList(){
        if let nextPub = list.nextPublishedString, nextPub != "" {
            bookService.loadList(id: list.id, timeString: nextPub){ [weak self] (loadedList) in
                if let list = loadedList {
                    if let stepsBack = self?.listStepsBack, stepsBack > 0 {
                        self?.listStepsBack -= 1
                    }
                    self?.list = list
                }
            }
        }
    }
    
    
}

extension BestSellerListViewModel : Hashable {
    
    static func == (lhs: BestSellerListViewModel, rhs: BestSellerListViewModel) -> Bool {
        return lhs.list.id == rhs.list.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(list.id)
    }
    
}

