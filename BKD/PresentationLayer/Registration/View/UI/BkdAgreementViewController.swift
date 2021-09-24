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
    
    //MARK: -- Outlets
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mAgreeBtn: UIButton!
    @IBOutlet weak var mAgreeBckgV: UIView!
    @IBOutlet weak var mAgreeLeading: NSLayoutConstraint!
    
    //MARK: -- Variables
    weak var delegate: BkdAgreementViewControllerDelegate?
    var isAdvanced:Bool = false
    
    //MARK: --Life cicle
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
    
    //Open SelectPayment screen
     private func goToSelectPayment() {
         
        let selectPaymentVC = SelectPaymentViewController.initFromStoryboard(name: Constant.Storyboards.payment)
        self.navigationController?.pushViewController(selectPaymentVC, animated: true)
    }
    
    
    ///Agree button move to right  with animation
    private func agreeClicked() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mAgreeLeading.constant = self.mAgreeBckgV.bounds.width - self.mAgreeBtn.frame.size.width
            self.mAgreeBckgV.layoutIfNeeded()
        } completion: { _ in
            
            if self.isAdvanced {
                
                self.goToSelectPayment()
                
            } else {
                self.delegate?.agreeTermsAndConditions()
                self.navigationController?.popViewController(animated: true)
            }
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
