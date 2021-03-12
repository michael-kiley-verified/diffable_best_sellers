//
//  Switchable.swift
//  BestSellers
//
//  Created by Michael Kiley on 3/11/21.
//

import Foundation
import UIKit

// Switchable is broken out into its own protocol to allow switchViewMode to be marked @objc
@objc protocol Switchable : AnyObject {
    func switchViewMode()
}

protocol SwitchableNavConfigurable : Switchable {
    var isInImageMode : Bool { get set }
    var imageRightBarButton : UIBarButtonItem {get}
    var textRightBarButton : UIBarButtonItem {get}
}

extension SwitchableNavConfigurable where Self : UIViewController {

    func setUpSwitchableNavBar(){
        self.navigationItem.setRightBarButton(textRightBarButton, animated: false)
    }

    var imageRightBarButton : UIBarButtonItem {
        let image = UIImage(systemName: "square.grid.3x2.fill")
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(switchViewMode))
        return buttonItem
    }

    var textRightBarButton : UIBarButtonItem {
        let image = UIImage(systemName: "text.justify")
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(switchViewMode))
        return buttonItem
    }


}
