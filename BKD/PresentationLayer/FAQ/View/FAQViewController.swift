//
//  FAQViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-01-22.
//

import UIKit
import WebKit

class FAQViewController: BaseViewController {

    @IBOutlet weak var mWebV: WKWebView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mActivityV: UIActivityIndicatorView!
    
    //MASK: -- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        tabBarController?.tabBar.isHidden = true
        mRightBarBtn.image = img_bkd
        mWebV.navigationDelegate = self
        loadWebView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mActivityV.startAnimating()
    }
    
    
    ///load web view
    func loadWebView() {
        let url = URL(string: "https://www.google.am")
        mWebV.load(URLRequest(url: url!))
    }

    //MASK: -- Action
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }


}


// MARK: - WKNavigation Delegate
extension FAQViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mActivityV.stopAnimating()
    }
}
