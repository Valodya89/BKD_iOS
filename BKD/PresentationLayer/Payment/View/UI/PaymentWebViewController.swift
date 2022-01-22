//
//  PaymentWebViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-07-21.
//

import UIKit
import WebKit

final class PaymentWebViewController: UIViewController, StoryboardInitializable, WKUIDelegate {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var mWebV: WKWebView!
    @IBOutlet weak private var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mActivityV: UIActivityIndicatorView!
    @IBOutlet weak private var mRightBarBtn: UIBarButtonItem!
    
    
    // MARK: - Properties
    var paymentType: PaymentType?
    private var urlString = ""
    private var htmlString = ""
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        configWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mActivityV.startAnimating()
        loadWebView()
    }
    
    
    // MARK: - IBActions
    
    @IBAction private func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    /// Configure webView
    private func configWebView() {
        //n
        let config = WKWebViewConfiguration()
        let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage('click clack!'); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")
        mWebV = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        
        mWebV.uiDelegate = self //n
        mWebV.navigationDelegate = self
        self.view = mWebV
    }
    
    /// Configure screen UI
    private func configUI() {
        mRightBarBtn.image = img_bkd
    }
    
    /// Load webView with url or htmlString
    private func loadWebView() {
        if let validURL = URL(string: urlString) {
            let request = URLRequest(url: validURL)
            mWebV.load(request)
        } else {
            mWebV.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    /// Set page data with URL
    func setData(urlString: String) {
        self.urlString = urlString
    }
    
    /// Set page data with htmlString
    func setData(htmlString: String) {
        self.htmlString = htmlString
    }
}


// MARK: - WKNavigation Delegate
extension PaymentWebViewController: WKNavigationDelegate {
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("request.url = ", navigationAction.request.url)
//        print("request = ", navigationAction.request)
//        if let host = navigationAction.request.url?.absoluteString {
//            if host == "https://dev-ipay.bkdrental.com/ipay/return" {
//                decisionHandler(.allow)
//                return
//            }
//        }
//
//        decisionHandler(.allow)
//    }
 //https://dev-ipay.bkdrental.com/ipay/return
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mActivityV.stopAnimating()
//        webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
//            guard let jsonString = jsonRaw as? String else { return }
//            //let json = JSON(parseJSON: jsonString)
//            // do stuff
//            print(jsonString)
//        })
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("navv === ",navigation.description)
        print("web ==== ", webView.url)
//        showLTActivityIndicator()
    }
    
}


extension PaymentWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message: \(message.body)")
            // and whatever other actions you want to take
        }
}
