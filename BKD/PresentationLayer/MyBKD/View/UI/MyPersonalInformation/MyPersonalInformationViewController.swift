//
//  MyPersonalInformationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit

class MyPersonalInformationViewController: BaseViewController {

    //Verified
    @IBOutlet weak var mVerifiedPendingLb: UILabel!
    @IBOutlet weak var mVerifiedLb: UILabel!
    @IBOutlet weak var mVerifiedImgV: UIImageView!
    
    @IBOutlet weak var mPersonalInfoTbV: myPersonalInfoTableView!
    @IBOutlet weak var mEdifBtn: UIButton!
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func edit(_ sender: UIButton) {
    }
}
