//
//  FaceAndTouchIdViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class FaceAndTouchIdViewController: UIViewController, StoryboardInitializable {
    
    //MARK: Outlet
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mAgreeBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.setBorder(color: color_menu!, width: 1)
        mAgreeBtn.layer.cornerRadius = 8
        mAgreeBtn.setBorder(color: color_menu!, width: 1)
    }
    
//MARK: ACTIONS
    @IBAction func cancel(_ sender: UIButton) {
        
    }
    
    @IBAction func agree(_ sender: UIButton) {
        
        sender.setClickBackgroundColor(color_menu!)
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
        
    }
    
}
