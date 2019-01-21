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
