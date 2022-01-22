//
//  NewDamageViewController.swift
//  NewDamageViewController
//
//  Created by Karine Karapetyan on 20-09-21.
//

import UIKit

protocol NewDamageViewControllerDelegate: AnyObject {
    func didPressConfirm()
    func didPressCancel()

    
}

class NewDamageViewController: UIViewController, StoryboardInitializable {

    //MARK: -- Outlets
    @IBOutlet weak var mContentV: UIView!
    @IBOutlet weak var mDamageImgV: UIImageView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mDemageTxtFl: TextField!
    
    //MARK: -- Variabl
    weak var delegate: NewDamageViewControllerDelegate?
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mDemageTxtFl.layer.borderColor = color_navigationBar!.cgColor

    }
    
    func setupView() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        mContentV.layer.borderWidth = 1.0
        mContentV.layer.borderColor = color_shadow!.cgColor
        mCancelBtn.layer.cornerRadius = 8
        mCancelBtn.layer.borderColor = color_menu!.cgColor
        mCancelBtn.layer.borderWidth = 1.0
        mConfirmBtn.layer.cornerRadius = 8
        mConfirmBtn.layer.borderColor = color_menu!.cgColor
        mConfirmBtn.layer.borderWidth = 1.0
        mConfirmBtn.backgroundColor = .clear
        mCancelBtn.backgroundColor = .clear
        mConfirmBtn.enable()
        mDemageTxtFl.setPlaceholder(string: Constant.Texts.damageName, font: font_placeholder!, color: color_chat_placeholder!)
        mDemageTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mDemageTxtFl.delegate = self
    }
    

 //MARK: -- Actions
    @IBAction func cancel(_ sender: UIButton) {
        sender.setClickColor(color_menu!, titleColor: sender.titleColor(for: .normal)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.didPressCancel()
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        sender.setClickColor(color_menu!, titleColor: sender.titleColor(for: .normal)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if  self.mDemageTxtFl.text == nil ||  self.mDemageTxtFl.text == "" {
                self.mDemageTxtFl.layer.borderColor = color_error!.cgColor
            } else {
                self.delegate?.didPressConfirm()
            }
        }
       
    }
       
}


//MARK: UITextFieldDelegate
//MARK: ---------------------------
extension NewDamageViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        let fullText = textField.text! + string
        if fullText.count > 0 {
            textField.layer.borderColor = color_navigationBar!.cgColor
        }
        return true
    }

}


