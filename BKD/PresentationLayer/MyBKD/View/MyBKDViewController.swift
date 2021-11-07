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
    var mainDriver: MainDriver?
    private lazy var signInVC = SignInViewController.initFromStoryboard(name: Constant.Storyboards.signIn)
    private lazy var viewModel = MyBKDViewModel()
    private var menu: SideMenuNavigationController?
    var isBackFromRegistrationBot = false
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isBackFromRegistrationBot {
            if viewModel.isUserSignIn {
                removeChild(vc: signInVC)
                self.getMainDriver()
                //signIn()
            } else {
                addSignInChild()
            }
            handlerSignIn()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isBackFromRegistrationBot = false
    }
    
    private func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mPrivacyPolicyLb.font = font_details_title
    }
    
    ///Add child ViewController
    private func addSignInChild() {
            addChild(signInVC)
            signInVC.view.frame = self.view.bounds
            self.view.addSubview(signInVC.view)
            signInVC.didMove(toParent: self)
    }
    
    ///Remove child ViewController
    private func removeChild(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
   
//    ///SignIn user
//    private func signIn() {
//        SignInViewModel().signIn(username: viewModel.userName,
//                                 password: viewModel.password) {[weak self] status in
//            guard let self = self else { return }
//            if status == .success {
//                self.getMainDriver()
//            } else {
//                self.addSignInChild()
//            }
//        }
//    }
    
    ///Log out account
    private func logOut() {
        viewModel.logout()
        addSignInChild()
    }
    
    ///Get main driver
    func getMainDriver() {
        viewModel.getMainDriver { response in
            if response == nil || (response?.id ?? "").count <= 0 || (response?.state ?? "") == Constant.Texts.state_created  {
                self.goToRegistrationBot(isDriverRegister: false,
                                         tableData: [RegistrationBotData.registrationBotModel[0]],
                                         mainDriver: nil)
            } else {
                self.mainDriver = response
                if self.mainDriver?.state != Constant.Texts.state_agree && self.mainDriver?.state != Constant.Texts.state_accepted  {
                    self.goToRegistrationBot(isDriverRegister: false,
                                             tableData: [RegistrationBotData.registrationBotModel[0]],
                                             mainDriver: self.mainDriver)
                }
            }
            
        }
    }
    
    //Go to registeration bot screen
    func goToRegistrationBot(isDriverRegister:Bool,
                             tableData: [RegistrationBotModel],
                             mainDriver: MainDriver?) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.delegate = self
        registrationBotVC.tableData = tableData
        registrationBotVC.isDriverRegister = isDriverRegister
        registrationBotVC.mainDriver = mainDriver
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
    
    //MARK: ACTIONS
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    
    ///Handler sign in
    func handlerSignIn() {
        signInVC.didSignIn = { [self] in
            self.removeChild(vc: self.signInVC)
            self.getMainDriver()
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

//MARK: RegistartionBotViewControllerDelegate
//MARK: ------------------------------------------
extension MyBKDViewController: RegistartionBotViewControllerDelegate {
    func backToMyBKD() {
        isBackFromRegistrationBot = true
    }
}
