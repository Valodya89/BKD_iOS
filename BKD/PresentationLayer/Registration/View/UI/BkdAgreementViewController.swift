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

class BkdAgreementViewController: BaseViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mAgreeV: ConfirmView!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
   
    
    //MARK: -- Variables
    weak var delegate: BkdAgreementViewControllerDelegate?
    var isAdvanced:Bool = false
    var isEditAdvanced:Bool = false
    var isMyReservationCell:Bool = false
    var isPayLater:Bool = false
    
    //MARK: --Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        mRightBarBtn.image = img_bkd
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mAgreeV.mConfirmLb.text = Constant.Texts.agree
        handlerAgree()
    }
    
    
  //MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlerAgree() {
        mAgreeV.didPressConfirm  = {
            if self.isAdvanced ||
                self.isMyReservationCell ||
                self.isPayLater ||
                self.isEditAdvanced  {
                
                self.goToSelectPayment()
                
            } else {
                self.delegate?.agreeTermsAndConditions()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
