//
//  EmailVerificationViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-07-21.
//

import UIKit

class EmailVerificationViewController: UIViewController, StoryboardInitializable {

    //MARK: Outlets
    @IBOutlet weak var mContinueBckgV: UIView!
    @IBOutlet weak var mContinueBtn: UIButton!
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mVerifiedSuccessBckgV: UIView!
    @IBOutlet weak var mSuccessLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func  setUpView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mVerifiedSuccessBckgV.layer.cornerRadius = 8
        mContinueBtn.layer.cornerRadius = 8
        mContinueBtn.addBorder(color:color_navigationBar!, width: 1.0)
    }
    
    
    ///Confirm button move to right  with animation
    private func clickContinue() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueBckgV.bounds.width - self.mContinueBtn.frame.size.width
            self.mContinueBckgV.layoutIfNeeded()
        } completion: { _ in
            self.mVerifiedSuccessBckgV.isHidden = false
            self.mVerifiedSuccessBckgV.popupAnimation()
        }
    }
    
    // MARK: ACTIONS
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func continueVerifications(_ sender: UIButton) {
        clickContinue()
    }
    
    @IBAction func continueSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        clickContinue()

    }
    @IBAction func thankYou(_ sender: UIButton) {
        mVerifiedSuccessBckgV.isHidden = true
        let FaceAndTouchIdVC = FaceAndTouchIdViewController.initFromStoryboard(name: Constant.Storyboards.registration)
        self.navigationController?.pushViewController(FaceAndTouchIdVC, animated: true)
    }
}
