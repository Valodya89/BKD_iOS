//
//  BkdAgreementViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit
import WebKit


protocol BkdAgreementViewControllerDelegate: AnyObject {
    func agreeTermsAndConditions()
}

class BkdAgreementViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mAgreeV: ConfirmView!
    @IBOutlet weak private var mWebV: WKWebView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mActivityIndicator: UIActivityIndicatorView!
    
    
    //MARK: -- Variables
    weak var delegate: BkdAgreementViewControllerDelegate?
    
    var isMyReservationCell:Bool = false
    var isPayLater:Bool = false
   // private var urlString = ""
    private var htmlString = ""
    
    public var isAdvanced:Bool = false
    public var isEditAdvanced:Bool = false
    public var urlString: String? = nil
    
    //MARK: --Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configWebView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
    }
    
    //MARK: -- Set
    func setUpView() {
        mRightBarBtn.image = img_bkd
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mAgreeV.mConfirmLb.text = Constant.Texts.agree
        handlerAgree()
    }
    
//    /// Set page data with URL
//    func setData(urlString: String) {
//        self.urlString = urlString
//    }
    
    /// Set page data with htmlString
    func setData(htmlString: String) {
        self.htmlString = htmlString
    }
    
    /// Configure webView
    private func configWebView() {
        mWebV.navigationDelegate = self
    }
    
    /// Load webView with url or htmlString
    private func loadWebView() {
        if let validURL = URL(string: urlString ?? "") {
            let request = URLRequest(url: validURL)
            mWebV.load(request)
        } else {
            mWebV.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
  //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerAgree() {
        mAgreeV.didPressConfirm  = {
            if self.isAdvanced ||
                self.isMyReservationCell ||
                self.isPayLater ||
                self.isEditAdvanced  {
                
                self.goToSelectPayment()
                
            } else {
                self.delegate?.agreeTermsAndConditions()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


// MARK: -- WKNavigation Delegate
extension BkdAgreementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        mActivityIndicator.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mActivityIndicator.stopAnimating()
    }
}
