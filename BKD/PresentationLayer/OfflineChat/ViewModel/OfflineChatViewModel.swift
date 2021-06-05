//
//  OfflineChatViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 04-06-21.
//

import UIKit

class OfflineChatViewModel: NSObject {
    static let shared = OfflineChatViewModel()
    let validator = Validator()

    //MARK: VALIDATION
    func isFillEmail(email: String, didResult: @escaping (Bool) -> ()) {
        
    }
}
