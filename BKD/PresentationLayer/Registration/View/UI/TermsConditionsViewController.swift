//
//  TermsConditionsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit
import WebKit
import SVProgressHUD

class TermsConditionsViewController: UIViewController, StoryboardInitializable {

    //MARK: Outlets
    @IBOutlet weak var mWebV: WKWebView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    public var urlString: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        tabBarController?.tabBar.isHidden = true
        mRightBarBtn.image = img_bkd!
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
    
    
// MARK: ACTION
 @IBAction func back(_ sender: UIBarButtonItem) {
     self.navigationController?.popViewController(animated: true)
 }

}


// MARK: - WKNavigation Delegate
extension TermsConditionsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
