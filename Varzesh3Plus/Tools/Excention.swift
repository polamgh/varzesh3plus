//
//  Excention.swift
//  Varzesh3Plus
//
//  Created by Ali Ghanavati on 10/30/1397 AP.
//  Copyright © 1397 AP Ali Ghanavati. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}


extension UIBarButtonItem {
    private struct AssociatedObject {
        static var key = "action_closure_key"
    }
    
    var actionClosure: (()->Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObject.key) as? ()->Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            target = self
            action = #selector(didTapButton(sender:))
        }
    }
    
    @objc func didTapButton(sender: Any) {
        actionClosure?()
    }
}
