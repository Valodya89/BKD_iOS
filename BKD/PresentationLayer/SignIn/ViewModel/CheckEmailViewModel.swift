//
//  CheckEmailViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

let mailUrls = ["message", "googlegmail", "yahooMail"]
let mailAppNames = ["Mail", "Google Mail", "Yahoo Mail"]

class CheckEmailViewModel: NSObject {
    //
//    func getEmailApps(didResult: @escaping ([String]?) -> ()) {
//        var appList:[String]? = []
//        for (i, item) in mailUrls.enumerated() {
//            if let appURL = NSURL(string: "\(item)://app") {
//                let canOpen = UIApplication.shared.canOpenURL(appURL as URL)
//                if canOpen {
//                    appList?.append(mailAppNames[i])
//                }
//                print("Can open \"\(appURL)\": \(canOpen)")
//            }
//        }
//        didResult(appList)
//    }

}
