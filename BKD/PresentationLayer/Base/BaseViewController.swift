//
//  BaseViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setmenu(menu: SideMenuNavigationController?) {
        menu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.leftMenuNavigationController = menu
        menu?.setNavigationBarHidden(true, animated: true)
        menu?.menuWidth = 310
        menu?.presentDuration = 0.8
    }
}
