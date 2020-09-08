//
//  Storyboard+Extensions.swift
//  TestTable
//
//  Created by user on 22.08.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//
import UIKit

enum AppStoryboard : String {
    case TableMainBoard
    
    var instance : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: BundleUtils.sdkBundle())
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryBoard(appStoryBorad: AppStoryboard) -> Self {
        return appStoryBorad.viewController(viewControllerClass: self)
    }
}
