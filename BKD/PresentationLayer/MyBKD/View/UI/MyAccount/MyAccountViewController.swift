//
//  MyAccountViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-12-21.
//

import UIKit

class MyAccountViewController: BaseViewController {

    //MARK: -- Outlets
    @IBOutlet weak var mChangePasswordBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mEmailTextFl: TextField!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationControll(navControll: navigationController, barBtn: mRightBarBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        configureUI()
    }
    
    ///Configutre UI
    func configureUI() {
        mChangePasswordBtn.layer.cornerRadius = 8
        mEmailTextFl.text = MyBKDViewModel().userName
    }

    // MARK: -- Actions

    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        self.goToEmailAddress()
    }
    
    @IBAction func edit(_ sender: UIButton) {
        let editVC = EditViewController.initFromStoryboard(name: Constant.Storyboards.myAccount)
        editVC.email = mEmailTextFl.text!
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
