//
//  Validation.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/27/23.
//

import Foundation
import UIKit

struct Validation {
    static func isValidName(_ name: String?) -> Bool {
        guard let name = name, !name.isEmpty else {
            return false
        }
        return true
    }
    
    static func isValidNumber(_ number: Int?) -> Bool {
        guard let number = number, (1...80).contains(number) else {
            return false
        }
        return true
    }
    
    static func showAlert(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
