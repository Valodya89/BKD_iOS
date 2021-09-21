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

class NewDamageViewController: UIViewController, StoryboardInitializable, UITextFieldDelegate {

    //MARK: -- Outlets
    @IBOutlet weak var mContentV: UIView!
    @IBOutlet weak var mDamageImgV: UIImageView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    @IBOutlet weak var mDemageTxtFl: TextField!
    
    //MARK: -- Variabl
    weak var delegate: NewDamageViewControllerDelegate?
    
    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
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
        mDemageTxtFl.setPlaceholder(string: Constant.Texts.damageName, font: font_placeholder!, color: color_chat_placeholder!)
        mDemageTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mDemageTxtFl.delegate = self
        
    }
    

 //MARK: -- Actions
    @IBAction func cancel(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        BKDAlert().showAlert(on: self, title: Constant.Texts.cancelDamage, message: nil, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.yesCancel) {
            sender.backgroundColor = .clear
        } okAction: {
            self.delegate?.didPressCancel()
            sender.backgroundColor = .clear

        }

    }
    
    @IBAction func confirm(_ sender: UIButton) {
        sender.backgroundColor = color_menu!
        delegate?.didPressConfirm()
    }
    
    
}
