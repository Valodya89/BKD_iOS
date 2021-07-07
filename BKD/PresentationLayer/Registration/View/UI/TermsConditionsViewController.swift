//
//  TermsConditionsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit
import WebKit

class TermsConditionsViewController: UIViewController, StoryboardInitializable {

    //MARK: Outlets
    @IBOutlet weak var mWebV: WKWebView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
 
    func setUpView() {
        mRightBarBtn.image = img_bkd
           let url = URL(string: "https://www.google.am")
           mWebV.load(URLRequest(url: url!))
    }
    
// MARK: ACTION
 @IBAction func back(_ sender: UIBarButtonItem) {
     self.navigationController?.popViewController(animated: true)
 }

}
