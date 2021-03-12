//
//  RootCoordinator.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import Foundation
import UIKit

class RootCoordinator: AppCoordinator {
    
    var children = [AppCoordinator]()
    var navigationController: UINavigationController
    var bookService : BookService

    init(navigationController: UINavigationController, bookService : BookService) {
        self.navigationController = navigationController
        self.bookService = bookService
    }

    func launch() {
        let listsViewModel = ListSummariesViewModel(bookService: bookService)
        let vc = AllListsViewController(viewModel: listsViewModel, appCoordinator: self)
        navigationController.pushViewController(vc, animated: false)
        listsViewModel.loadListSummaries()
    }
    
    func viewListDetail(listViewModel : BestSellerListViewModel) {
        let vc = ListViewController(viewModel: listViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
}


protocol AppCoordinator : AnyObject {
    var children : [AppCoordinator] { get set}
    var navigationController : UINavigationController { get set }
    
    func launch()
    func viewListDetail(listViewModel : BestSellerListViewModel)
}
