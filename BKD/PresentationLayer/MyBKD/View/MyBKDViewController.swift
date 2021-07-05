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
    var menu: SideMenuNavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    func setUpView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        mPrivacyPolicyLb.font = font_details_title
        addChild(vc: signInVC as SignInViewController)

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
    
    
}
