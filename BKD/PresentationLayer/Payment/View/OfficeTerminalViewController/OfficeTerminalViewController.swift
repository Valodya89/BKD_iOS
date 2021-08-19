//
//  OfficeTerminalViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 13-08-21.
//

import UIKit

class OfficeTerminalViewController: UIViewController {

    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mInfoLb: UILabel!
    @IBOutlet weak var mAskAdminBtn: UIButton!
    @IBOutlet weak var mNumberTextFl: OneTimeCodeTextField!
    @IBOutlet weak var mOfficeInfoV: BkdOfficeInfoView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    

    func configureUI() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd")
        mAskAdminBtn.roundCornersWithBorder(corners: .allCorners, radius: 8.0, borderColor: color_menu!, borderWidth: 1)
        mNumberTextFl.defaultCharacter = Constant.Texts.generatedCode
        mNumberTextFl.configure(with: 5)
    }

 
    //MARK: -- Actions
    
    @IBAction func changeTextFiled(_ sender: OneTimeCodeTextField) {
        if mNumberTextFl.text?.count == 5 {
            mAskAdminBtn.isEnabled = true
            mAskAdminBtn.setTitleColor(color_email!, for: .normal)

        } else {
            mAskAdminBtn.isEnabled = false
            mAskAdminBtn.setTitleColor(color_navigationBar!, for: .normal)

        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func askAdmin(_ sender: UIButton) {
        sender.setBackgroundColorToCAShapeLayer(color: color_menu!)
        
    }
}
