//
//  ListDetailViewController.swift
//  BestSellers
//
//  Created by Michael Kiley on 2/26/21.
//

import UIKit

class ListViewController: UIViewController, SwitchableNavConfigurable {
    
    var bestSellerListViewModel : BestSellerListViewModel!
    
    var dataSource: UICollectionViewDiffableDataSource<BestSellerListViewModel, String>!
    var collectionView: UICollectionView!
    
    var leftSwipeGestureRecognizer : UISwipeGestureRecognizer!
    var rightSwipeGestureRecognizer : UISwipeGestureRecognizer!
    
    var isInImageMode: Bool = true
    
    lazy var dateView : ListDateView = {
        let dateView = ListDateView()
        dateView.translatesAutoresizingMaskIntoConstraints = false
        return dateView
    }()
    
    convenience init(viewModel : BestSellerListViewModel){
        self.init()
        bestSellerListViewModel = viewModel
        viewModel.observorDelegate = self
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpSubviews()
        setUpDataSource()
        setUpGestures()
    }
    
}

extension ListViewController : ViewModelObservor {
    func didUpdateViewModel() {
        refreshSnapshot()
        updateDateView()
    }
    
    func updateDateView(){
        DispatchQueue.main.async {
            self.dateView.dateLabel.text = self.bestSellerListViewModel.getListAge()
        }
    }
}

// Switchable nav bar setup
extension ListViewController {
    func setUpNavBar(){
        navigationItem.title = bestSellerListViewModel.getFormattedName()
        setUpSwitchableNavBar()
    }
    
    @objc func switchViewMode(){
        isInImageMode = !isInImageMode
        navigationItem.setRightBarButton(isInImageMode ? textRightBarButton : imageRightBarButton, animated: true)
        collectionView.collectionViewLayout = isInImageMode ? createImageLayout() : createTextLayout()
        refreshSnapshot(animatingDifferences: false)
    }
}

// Setting up subview layouts
extension ListViewController {
    
    func setUpSubviews() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createImageLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        view.addSubview(dateView)
        NSLayoutConstraint.activate([
            dateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dateView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        
    }
    
    func createImageLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createTextLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(10), trailing: .fixed(0), bottom: .fixed(0))

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// Setting up data source
extension ListViewController {
    
    func setUpDataSource() {
        let textCellRegistration = createTextCellRegistration()
        let imageCellRegistration = createImageCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<BestSellerListViewModel, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            if(self.isInImageMode){
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: identifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: identifier)
            }
        }

        refreshSnapshot()
    }
    
    func createTextCellRegistration()->UICollectionView.CellRegistration<BookTextCell, String>{
        return UICollectionView.CellRegistration<BookTextCell, String> { (cell, indexPath, bookTitle) in
            if let bookVM = self.bestSellerListViewModel.bookViewModels.first(where: { $0.getTitle() == bookTitle}){
                cell.titleLabel.text = bookVM.getTitle()
                cell.authorLabel.text = bookVM.getAuthor()
            }
        }
    }
    
    func createImageCellRegistration()->UICollectionView.CellRegistration<BookImageCell, String> {
        return UICollectionView.CellRegistration <BookImageCell, String> { (cell, indexPath, bookTitle) in
            if let bookVM = self.bestSellerListViewModel.bookViewModels.first(where: { $0.getTitle() == bookTitle}){
                bookVM.loadCoverImage { (data) in
                    DispatchQueue.main.async{
                        cell.imageView.image = UIImage(data: data)
                        cell.loadingAnimationView.stop()
                        cell.loadingAnimationView.isHidden = true
                        cell.imageView.layer.borderWidth = 0
                    }
                }
            }
        }
    }
    
    
    func refreshSnapshot(animatingDifferences : Bool = true) {
        if let _ = dataSource{
            var currentSnapshot = NSDiffableDataSourceSnapshot<BestSellerListViewModel, String>()
            
            currentSnapshot.appendSections([bestSellerListViewModel])
            currentSnapshot.appendItems(bestSellerListViewModel.bookViewModels.map { $0.getTitle()})
            
            DispatchQueue.main.async{
                self.dataSource.apply(currentSnapshot, animatingDifferences: animatingDifferences)
            }
            
        }
    }
}

// Setting up gestures
extension ListViewController {
    
    func setUpGestures(){
        self.view.isUserInteractionEnabled = true
        
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        leftSwipeGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped))
        rightSwipeGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
    }
    
    @objc func swiped(_ gestureRecognizer : UISwipeGestureRecognizer){
        switch gestureRecognizer.direction {
        case .right:
            bestSellerListViewModel.loadOlderList()
        case .left:
            bestSellerListViewModel.loadNewerList()
        default:
            print("swiped in unsupported direction")
        }
    }
    
    
}
