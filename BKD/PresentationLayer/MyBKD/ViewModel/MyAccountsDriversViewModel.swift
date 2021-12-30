//
//  MyAccountsDriversViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-12-21.
//

import UIKit

final class MyAccountsDriversViewModel {
    
    ///Get active drivers list
    func getActiveDrivers(drivers: [MainDriver]) -> [MainDriver] {
        var activeDriver: [MainDriver] = []
        for driver in drivers {
            if driver.state == Constant.Texts.state_agree || driver.state == Constant.Texts.state_accepted {
                activeDriver.append(driver)
            }
        }
        return activeDriver
    }
}
