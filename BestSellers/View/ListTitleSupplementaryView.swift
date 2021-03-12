//
//  ListTitleSupplementaryView.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/1/21.
//

import UIKit

class ListTitleSupplementaryView: UICollectionReusableView {
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    lazy var viewAllButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(ListTitleSupplementaryView.viewAllButtonTapped(sender:)), for: .touchUpInside)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        return button
    }()
    
    weak var titleDelegate : ViewListButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ListTitleSupplementaryView {
    func setUpSubviews() {
        
        addSubview(label)
        addSubview(viewAllButton)
        
        let padding = CGFloat(10)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -padding),
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            viewAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            viewAllButton.heightAnchor.constraint(equalToConstant: 20),
            viewAllButton.widthAnchor.constraint(equalToConstant: 40),
            viewAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
}

extension ListTitleSupplementaryView {
    @objc func viewAllButtonTapped(sender : UIButton){
        titleDelegate?.viewAllButtonPressed(listTitle: label.text)
    }
}

protocol ViewListButtonDelegate : AnyObject {
    func viewAllButtonPressed(listTitle : String?)
}

