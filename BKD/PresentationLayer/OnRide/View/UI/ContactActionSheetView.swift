//
//  ContactActionSheetView.swift
//  ContactActionSheetView
//
//  Created by Karine Karapetyan on 22-09-21.
//

import UIKit

class ContactActionSheetView: UIView {

    //MARK: -- Outlets
    @IBOutlet weak var mPhoneNumberBtn: UIButton!
    @IBOutlet weak var mcancelBtn: UIButton!
    
    //MARK: -- Variables
    var callByNumber:((String)-> Void)?
    var cancel:(()-> Void)?
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        mPhoneNumberBtn.layer.cornerRadius = 8
        mcancelBtn.layer.cornerRadius = 8
        mPhoneNumberBtn.setShadow(color: color_shadow!)
        mcancelBtn.setShadow(color: color_shadow!)
    }
    
    
    //MARK: --Actions
    @IBAction func callByNumber(_ sender: UIButton) {
        callByNumber?(sender.title(for: .normal) ?? "")
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        cancel?()
    }

}
