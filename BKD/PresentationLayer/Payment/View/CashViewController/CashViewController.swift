//
//  CashViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-08-21.
//

import UIKit

class CashViewController: UIViewController {

    //MARK: -- Outlet
    @IBOutlet weak var mBkdOfficeInfoV: BkdOfficeInfoView!
    @IBOutlet weak var mAskAdminBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBArBtn: UIBarButtonItem!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func  configureUI() {
        mRightBArBtn.image = #imageLiteral(resourceName: "bkd")
        mAskAdminBtn.roundCornersWithBorder(corners: .allCorners, radius: 8.0, borderColor: color_menu!, borderWidth: 1)
    }
    

    //MARK: -- Action
    @IBAction func askAdmin(_ sender: UIButton) {
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)

        
    }
    

}
