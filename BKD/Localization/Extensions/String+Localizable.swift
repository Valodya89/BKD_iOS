//
//  String+Localizable.swift
//  hay
//
//  Created by Vardan Gevorgyan on 2/10/20.
//  Copyright © 2020 Sedrak Igityan. All rights reserved.
//

import Foundation


// MARK: - Localized String -

/// String extension for localizable functionality
extension String {
    var storageManager: StorageManager {
        return .init()
    }
    
    /// Use this method to localize string
    func localized() -> String {
        return LocalizationModel.shared?.getText(for: self) ?? self
    }
    
    /// Use this method to get key from value
    func getKey() -> String {
        let keyString = LocalizationModel.shared?.getKey(from: self)
        
        /// Get key from value
        return keyString ?? self
    }
}
