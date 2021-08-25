//
//  AppDelegate.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-05-21.
//

import UIKit
import GooglePlaces
import GoogleMaps

let googleApiKey = "AIzaSyC6MtPGDDn75eV2rMXG-8176Vasir7yF20"
//let googleApiKey = "AIzaSyB85-eNjtVzdJ58tyYhVG7jnFkfh9ZK8OI"

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    //static let GOOGLE_MAPS_API_KEY = "AIzaSyBBnsPKB01veDAEZd0MYs13FFuwJJi7KKo"
    //AIzaSyB85-eNjtVzdJ58tyYhVG7jnFkfh9ZK8OI
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        ApplicationSettings.construct()
        KeychainManager().resetIfNeed()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)

        let viewItem = urlComponent?.queryItems?.first(where: { $0.name == "view" })

        guard let view = viewItem?.value else {return true}
        let codeItem = urlComponent?.queryItems?.first(where: { $0.name == "code" })
        guard let code = codeItem?.value else {return true}
        var notification: Notification
        
        if view == Constant.Texts.verification {
            notification = Notification(name: Constant.Notifications.signUpEmailVerify, object: code)
            
        } else {///Reset password
            notification = Notification(name: Constant.Notifications.resetPassEmailVerify, object: code)
        }

        NotificationCenter.default.post(notification)
        return true
    }


}


