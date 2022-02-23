//
//  AboutUSViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import  SideMenu
import WebKit
import SVProgressHUD


class AboutUsViewController: BaseViewController {
    
    
    @IBOutlet weak var mWebV: WKWebView!
    @IBOutlet weak var mRightbarBtn: UIBarButtonItem!
    var menu: SideMenuNavigationController?
    public var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        tabBarController?.tabBar.isHidden = true
//        menu = SideMenuNavigationController(rootViewController: LeftViewController())
//        self.setmenu(menu: menu)
        mRightbarBtn.image = img_bkd
        mWebV.navigationDelegate = self
        loadWebView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.show()
    }
    
    ///load web view
    func loadWebView() {
        let url = URL(string: urlString ?? "")
        guard let _ = url else {return}
        mWebV.load(URLRequest(url: url!))
    }
    
    
    
    @IBAction func menu(_ sender: UIBarButtonItem) {
       // present(menu!, animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

    }
    
}


// MARK: - WKNavigation Delegate
extension AboutUsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            SVProgressHUD.dismiss()
    }
}
