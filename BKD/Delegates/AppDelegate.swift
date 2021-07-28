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


        return true
    }


}


