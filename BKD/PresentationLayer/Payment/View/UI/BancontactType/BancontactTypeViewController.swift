//
//  BancontactTypeViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-07-21.
//

import UIKit

class BancontactTypeView: UIView{

    @IBOutlet weak var mContentVBottom: NSLayoutConstraint!
    @IBOutlet weak var mContentV: UIView!
    var didPressMobileBancking:(() -> Void)?
    var didPressBancontact:(() -> Void)?
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        mContentV.layer.cornerRadius = 22
    }

    @IBAction func bancontact(_ sender: UIButton) {
        self.didPressBancontact?()
    }
    
    @IBAction func mobileBanking(_ sender: UIButton) {
        self.didPressMobileBancking?()
    }
    


}
