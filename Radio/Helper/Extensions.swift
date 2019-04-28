//
//  Extensions.swift
//  Radio
//
//  Created by Keval Patel on 4/27/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
import UIKit
extension Array where Element:Equatable {
    /**
     Remove Duplicate elements of array
     - Returns: Array with unique elements
     */
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension UIViewController {
    /**
     Function that pop up limited internet connectivity alertView
     */
    func noInternetAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect your device to Internet", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    /**
     Function that pop up error alertView with OK button
     - Parameters: Error title string and Error Message string
     */
    func errorAlert(_ title: String,_ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OkAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

