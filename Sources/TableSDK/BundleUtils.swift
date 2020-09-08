//
//  BundleUtils.swift
//  Table SDK
//
//  Created by user on 07.09.2020.
//  Copyright © 2020 TableCO. All rights reserved.
//

import Foundation

class BundleUtils {
    
    public static func sdkBundle() -> Bundle {
        
        return Bundle(for: Self.self)
    }
}
