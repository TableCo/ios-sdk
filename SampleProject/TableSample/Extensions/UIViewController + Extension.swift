//
//  UIViewController + Extension.swift
//  TableSample
//
//  Created by user on 28.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Show AlertView
    func showAlert(_ title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.present(alertController, animated: true)
            }
        } else {
            present(alertController, animated: true)
        }
        
    }
}
