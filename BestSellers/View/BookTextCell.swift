//
//  BookTextCell.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/1/21.
//


import UIKit

class BookTextCell: UICollectionViewCell {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension BookTextCell {
    func setUpSubviews() {
        
        let padding = CGFloat(10)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
