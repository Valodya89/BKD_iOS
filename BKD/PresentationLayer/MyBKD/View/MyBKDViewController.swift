//
//  MyBKDViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class MyBKDViewController: BaseViewController {

    //MARK:Outlets
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    //MARK: Variables
    private lazy  var signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
    private lazy  var emailAddressVC = EmailAddressViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
    var menu: SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    func setUpView() {
        mRightBarBtn.image = img_bkd
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        addChild(vc: signInVC as SignInViewController)
        didPressForgotPassword()
    }

    ///Add child ViewController
    func addChild(vc: UIViewController) {
        addChild(vc)
        vc.view.frame = self.view.bounds
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    ///Remove child ViewController
    func removeChild(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    func didPressForgotPassword() {
        signInVC.didPressForgotPassword = { [weak self] in
            self?.removeChild(vc: self!.signInVC as SignInViewController)
            self?.addChild(vc: self!.emailAddressVC as EmailAddressViewController)
        }
    }
    
    //MARK: ACTIONS
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    
}
