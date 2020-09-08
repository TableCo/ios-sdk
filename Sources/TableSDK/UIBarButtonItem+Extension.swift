//
//  UIBarButtonItem+Extension.swift
//  TestTable
//
//  Created by user on 25.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return !isEnabled && tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : #colorLiteral(red: 0.5051552653, green: 0.5590096116, blue: 0.5779797435, alpha: 1)
            isEnabled = !newValue
        }
    }
}
