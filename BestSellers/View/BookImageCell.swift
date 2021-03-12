//
//  BookImageCell.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/5/21.
//

import UIKit
import Lottie


class BookImageCell: UICollectionViewCell {

    let imageView = UIImageView()
    var loadingAnimationView : AnimationView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        loadingAnimationView.play()
        loadingAnimationView.isHidden = false
        imageView.layer.borderWidth = 10
    }
}

extension BookImageCell {
    
    func setUpSubviews() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = .red


        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        imageView.layer.borderWidth = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingAnimationView =  AnimationView(name: "book_loading_animation")
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingAnimationView)
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()


        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            loadingAnimationView.heightAnchor.constraint(equalToConstant: 50),
            loadingAnimationView.widthAnchor.constraint(equalToConstant: 50),
            loadingAnimationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
    
}
