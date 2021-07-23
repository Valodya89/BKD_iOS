//
//  PaymentWebViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-07-21.
//

import UIKit
import WebKit

class PaymentWebViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var mWebV: WKWebView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
   var paymentType: PaymentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mRightBarBtn.image = img_bkd
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
   

}
