//
//  UIViewController+Extension.swift
//  TestTable
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Show AlertView
    func showAlert(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
