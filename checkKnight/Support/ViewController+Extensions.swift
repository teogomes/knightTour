//
//  ViewController+Extensions.swift
//  checkKnight
//
//  Created by Teodoro Gomes on 4/7/20.
//  Copyright © 2020 Teodoro Gomes. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title:String,message:String,buttonTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
