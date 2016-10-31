//
//  Helper.swift
//  eword
//
//  Created by Admin on 29/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class Util {
    class func showAlertMessage(title: String, message: String, parent: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        parent.present(alert, animated: true, completion: nil)
    }
}
