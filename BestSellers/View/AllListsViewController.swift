//
//  AllListsViewController.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import UIKit

class AllListsViewController: UIViewController, SwitchableNavConfigurable {
    
    weak var appCoordinator : AppCoordinator?
    
    var listSummariesViewModel : ListSummariesViewModel!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<BestSellerListViewModel, BookViewModel>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<BestSellerListViewModel, BookViewModel>!
    
    var isInImageMode : Bool = true
    
    convenience init(viewModel : ListSummariesViewModel, appCoordinator : AppCoordinator){
        self.init()
        listSummariesViewModel = viewModel
        listSummariesViewModel.delegate = self
        self.appCoordinator = appCoordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUpNavBar()
        setUpCollectionViewLayout()
        setUpDataSource()
    }
    
}

extension AllListsViewController : ViewModelObservor {
    func didUpdateViewModel() {
        refreshSnapshot()
    }
}

// Switchable nav bar setup
extension AllListsViewController {
    func setUpNavBar(){
        navigationItem.title = "Best Sellers"
        setUpSwitchableNavBar()
    }
    
    @objc func switchViewMode(){
        isInImageMode = !isInImageMode
        navigationItem.setRightBarButton(isInImageMode ? textRightBarButton : imageRightBarButton, animated: true)
        collectionView.collectionViewLayout = isInImageMode ? createImageLayout() : createTextLayout()
        refreshSnapshot()
    }
}

// Collection layout setup
extension AllListsViewController {
    func setUpCollectionViewLayout() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: isInImageMode ? createImageLayout() : createTextLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createImageLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            //let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .flexible(10)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            section.boundarySupplementaryItems = [self.createTitleSupplementaryLayout()]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func createTitleSupplementaryLayout()->NSCollectionLayoutBoundarySupplementaryItem{
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: ElementKind.title.rawValue, alignment: .top)
        return titleSupplementary
    }
    
    func createTextLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .flexible(10)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            section.boundarySupplementaryItems = [self.createTitleSupplementaryLayout()]
            
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

// Collection DataSource setup
extension AllListsViewController {
    
    func setUpDataSource() {
        
        let textCellRegistration = createTextCellRegistration()
        let imageCellRegistration = createImageCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<BestSellerListViewModel, BookViewModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: BookViewModel) -> UICollectionViewCell? in
            if(self.isInImageMode){
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: identifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: identifier)
            }
        }
        
        let supplementaryRegistration = createTitleSupplementaryRegistration()
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        refreshSnapshot()
    }
    
    func createTextCellRegistration()->UICollectionView.CellRegistration<BookTextCell, BookViewModel>{
        return UICollectionView.CellRegistration<BookTextCell, BookViewModel> { (cell, indexPath, bookViewModel) in
            cell.titleLabel.text = bookViewModel.getTitle()
            cell.authorLabel.text = bookViewModel.getAuthor()
        }
    }
    
    func createImageCellRegistration()->UICollectionView.CellRegistration<BookImageCell, BookViewModel> {
        return UICollectionView.CellRegistration <BookImageCell, BookViewModel> { (cell, indexPath, bookViewModel) in
            bookViewModel.loadCoverImage { (data) in
                DispatchQueue.main.async{
                    cell.imageView.image = UIImage(data: data)
                    cell.loadingAnimationView.stop()
                    cell.loadingAnimationView.isHidden = true
                    cell.imageView.layer.borderWidth = 0
                }
            }
        }
    }
    
    func createTitleSupplementaryRegistration()->UICollectionView.SupplementaryRegistration<ListTitleSupplementaryView>{
        return UICollectionView.SupplementaryRegistration<ListTitleSupplementaryView>(elementKind: ElementKind.title.rawValue) {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let listViewModel = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.titleDelegate = self
                supplementaryView.label.text = listViewModel.getFormattedName()
            }
        }
    }
    
    func refreshSnapshot() {
        if let _ = dataSource{
            currentSnapshot = NSDiffableDataSourceSnapshot<BestSellerListViewModel, BookViewModel>()
            listSummariesViewModel.listViewModels.forEach {
                let listViewModel = $0
                currentSnapshot.appendSections([listViewModel])
                currentSnapshot.appendItems(listViewModel.bookViewModels)
            }
            DispatchQueue.main.async{
                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
            }
            
        }
    }
}


extension AllListsViewController : ViewListButtonDelegate {
    
    func viewAllButtonPressed(listTitle: String?) {
        if let listViewModel = listSummariesViewModel.listViewModels.first(where: { $0.getFormattedName() == listTitle }) {
            listViewModel.loadFullList()
            appCoordinator?.viewListDetail(listViewModel: listViewModel)
        }
    }
    
}

enum ElementKind : String {
    case title
}

