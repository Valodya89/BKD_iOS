//
//  AboutUSViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import  SideMenu

class AboutUsViewController: BaseViewController {
    var menu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
