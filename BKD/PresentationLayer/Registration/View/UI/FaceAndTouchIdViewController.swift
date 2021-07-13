//
//  FaceAndTouchIdViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class FaceAndTouchIdViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlet
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mAgreeBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mRightBarBtn.image = img_bkd
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    
    func setUpView() {
        mAgreeBtn.backgroundColor = .clear
        mCancelBtn.backgroundColor = .clear
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1)
        mAgreeBtn.layer.cornerRadius = 8
        mAgreeBtn.setBorder(color: color_menu!, width: 1)
    }
    
//MARK: ACTIONS
    @IBAction func cancel(_ sender: UIButton) {
        
    }
    
    @IBAction func agree(_ sender: UIButton) {
        
        sender.setClickColor(color_menu!, titleColor: sender.titleColor(for: .normal)! )
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = [RegistrationBotData.registrationBotModel[0]]
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
        navigationController?.popToViewController(ofClass: RegistrationViewController.self)

    }
}
