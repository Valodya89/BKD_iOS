//
//  BancontactView.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-07-21.
//

enum BancontactCard: Int {
    case ing
    case bnp
    case kbc
    case bancontact
}
import UIKit

class BancontactView: UIView {

    @IBOutlet weak var mContentV: UIView!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mContentVBottom: NSLayoutConstraint!
    
    var didPressBancontactCard:((BancontactCard) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        
    }
    
    func  setUpView() {
        mContentV.layer.cornerRadius = 22
        
    }
    
    
    //MARK: Actions
    @IBAction func ingBanc(_ sender: UIButton) {
        self.didPressBancontactCard?(BancontactCard(rawValue: sender.tag)!)
    }
    
    @IBAction func bnpBank(_ sender: UIButton) {
        self.didPressBancontactCard?(BancontactCard(rawValue: sender.tag)!)
    }
    
    
    @IBAction func kbcBank(_ sender: UIButton) {
        self.didPressBancontactCard?(BancontactCard(rawValue: sender.tag)!)
    }
}




