//
//  AddDamageViewController.swift
//  AddDamageViewController
//
//  Created by Karine Karapetyan on 22-09-21.
//

import UIKit

let phoneInsuance = "+32 (0) 3 255 63 45"
let phoneBkd = "+32 (0) 3 282 63 33"

class AddDamageViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var mContactActionSheet: ContactActionSheetView!
    @IBOutlet weak var mActionSheetBottom: NSLayoutConstraint!
    
    @IBOutlet weak var mContactInsuranceBtn: UIButton!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mVisualEffectV: UIVisualEffectView!
    @IBOutlet weak var mContactBkdBtn: UIButton!
    @IBOutlet weak var mAddAccidentDetailsBtn: UIButton!
    @IBOutlet weak var mInfoLb: UILabel!
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: -- Lide cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        mRightBarBtn.image = img_bkd
        mAddAccidentDetailsBtn.layer.cornerRadius = 5
        mContactBkdBtn.layer.cornerRadius = 8
        mContactInsuranceBtn.layer.cornerRadius = 8
        mContactBkdBtn.setBorder(color: color_menu!, width: 1.0)
        mContactInsuranceBtn.setBorder(color: color_menu!, width: 1.0)
        mGradientV.setGradient(startColor: .white, endColor: color_navigationBar!)

        handlerActionSheet()
        
    }
    
    ///Show ActionSheet of contact
    func showContactActionSheet(phone: String) {
        
        mContactActionSheet.mPhoneNumberBtn.setTitle(phone, for: .normal)
        mVisualEffectV.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.mActionSheetBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    ///Hide Contact ActionSheet
    func hideContactActionSheet() {
        UIView.animate(withDuration: 0.5) {
            self.mActionSheetBottom.constant = -200
            self.view.layoutIfNeeded()

        } completion: { _ in
            self.mContactBkdBtn.backgroundColor = .clear
            self.mContactInsuranceBtn.backgroundColor = .clear
            self.mVisualEffectV.isHidden = true
        }
    }
    
    //Call by phone number
    func phoneClick(phone: String) {
        
        if let callUrl = URL(string: "tel://\("+(56)975270693")"), UIApplication.shared.canOpenURL(callUrl) {
                    UIApplication.shared.open(callUrl)
        }
    }

   //MARK: -- Actions
    @IBAction func contactInsuance(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        showContactActionSheet(phone: phoneInsuance)
    }
    
    @IBAction func contactBKD(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        showContactActionSheet(phone: phoneBkd)
    }
    
    
    @IBAction func AddAccidentDetails(_ sender: UIButton) {
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /// Handler custom actionSheet actions
    func handlerActionSheet() {
        mContactActionSheet.callByNumber = { phone in
            self.phoneClick(phone: phone)
        }
        
        mContactActionSheet.cancel = {
            self.hideContactActionSheet()
        }
    }
}
