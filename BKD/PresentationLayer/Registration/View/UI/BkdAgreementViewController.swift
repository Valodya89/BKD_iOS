//
//  BkdAgreementViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 08-07-21.
//

import UIKit

protocol BkdAgreementViewControllerDelegate: AnyObject {
    func agreeTermsAndConditions()
}

class BkdAgreementViewController: UIViewController, StoryboardInitializable {
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mAgreeBtn: UIButton!
    @IBOutlet weak var mAgreeBckgV: UIView!
    @IBOutlet weak var mAgreeLeading: NSLayoutConstraint!
    
    weak var delegate: BkdAgreementViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mAgreeBtn.layer.cornerRadius = 8
        mAgreeBtn.layer.cornerRadius = 8
        mAgreeBtn.addBorder(color:color_navigationBar!, width: 1.0)
    }

    ///Agree button move to right  with animation
    private func agreeClicked() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mAgreeLeading.constant = self.mAgreeBckgV.bounds.width - self.mAgreeBtn.frame.size.width
            self.mAgreeBckgV.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.agreeTermsAndConditions()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func agree(_ sender: UIButton) {
        agreeClicked()
    }
    
    @IBAction func agreeSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        agreeClicked()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
