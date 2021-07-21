//
//  MyBKDViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class MyBKDViewController: BaseViewController {

    //MARK:Outlet
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mTableV: UITableView!
    @IBOutlet weak var mPrivacyPolicyLb: UILabel!
    
    //MARK: Variables
    private lazy  var signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
    private lazy var myBKDViewModel = MyBKDViewModel()
    var menu: SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSignInChild()

    }
    func setUpView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mPrivacyPolicyLb.font = font_details_title
    }
    
    

    ///Add child ViewController
    func addSignInChild() {
        
        if UserDefaults.standard.object(forKey: key_isLogin) == nil  {
            
            addChild(signInVC)
            signInVC.view.frame = self.view.bounds
            self.view.addSubview(signInVC.view)
            signInVC.didMove(toParent: self)
        } else {
            signInVC.willMove(toParent: nil)
            signInVC.view.removeFromSuperview()
            signInVC.removeFromParent()
        }
        
        
    }
    
    ///Remove child ViewController
    func removeChild(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    

    //MARK: ACTIONS
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
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
            UserDefaults.standard.removeObject(forKey: key_isLogin)
            myBKDViewModel.logout()
            addSignInChild()
            
        }
    }
    
}
