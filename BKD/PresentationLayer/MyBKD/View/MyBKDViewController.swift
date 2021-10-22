//
//  MyBKDViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu

final class MyBKDViewController: BaseViewController {
    
    //MARK:Outlet
    @IBOutlet weak private var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak private var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak private var mTableV: UITableView!
    @IBOutlet weak private var mPrivacyPolicyLb: UILabel!
    
    //MARK: Variables
    private lazy var signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
    private lazy var viewModel = MyBKDViewModel()
    private var menu: SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addSignInChild()
        handlerSignIn()
    }
    
    
    private func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_navigationBar!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mPrivacyPolicyLb.font = font_details_title
    }
    
    ///Add child ViewController
    private func addSignInChild() {
        if viewModel.isUserSignIn {
            signInVC.willMove(toParent: nil)
            signInVC.view.removeFromSuperview()
            signInVC.removeFromParent()
        } else {
            addChild(signInVC)
            signInVC.view.frame = self.view.bounds
            self.view.addSubview(signInVC.view)
            signInVC.didMove(toParent: self)
        }
    }
    
    ///Remove child ViewController
    private func removeChild(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    private func logOut() {
        viewModel.logout()
        addSignInChild()
    }
    
    //MARK: ACTIONS
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    
    func handlerSignIn() {
        signInVC.didSignIn = { [self] in
            self.removeChild(vc: self.signInVC)
        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
//MARK: ------------------------------------------
extension MyBKDViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  MyBkdData.myBkdModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyBkdTableViewCell.identifier, for: indexPath) as! MyBkdTableViewCell
        let item = MyBkdData.myBkdModel[indexPath.row]
        cell.mImageV.image = item.img
        cell.mTitleLb.text = item.title
        cell.mImageV.setTintColor(color: color_email!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            logOut()
        }
    }
}
