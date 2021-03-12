//
//  ListDateLabel.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/11/21.
//

import UIKit

class ListDateView: UIView {
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Latest list"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.customDarkBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.customLightBlue
        
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
