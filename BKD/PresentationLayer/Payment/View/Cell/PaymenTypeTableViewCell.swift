//
//  PaymenTypeTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

enum PaymentType: Int {
    case creditCard
    case bancontact
    case applePay
    case payPal
    case kaartlazer
    case officeTerminal

}
import UIKit

class PaymenTypeTableViewCell: UITableViewCell {
static let identifier = "PaymenTypeTableViewCell"
    
    @IBOutlet weak var mPaymentBtn: UIButton!
    @IBOutlet weak var mCardImgV: UIImageView!
    
    var didPressPayment:((PaymentType) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    func setUpView() {
        mPaymentBtn.roundCornersWithBorder(corners: .allCorners, radius: 5, borderColor: color_navigationBar!, borderWidth: 1)
    }
    
    override func prepareForReuse() {
        mPaymentBtn.setTitle("", for: .normal)
        mPaymentBtn.setImage(nil, for: .normal)
    }
    
    /// Set cell info
    func setCellInfo(item: PaymentTypes, index: Int) {
        mPaymentBtn.tag = index
        mPaymentBtn.addTarget(self, action: #selector(pressedPayment(sender:)), for: .touchUpInside)
        if let img = item.image {
           // mCardImgV.isHidden = false
            mPaymentBtn.setTitle("", for: .normal)
            mPaymentBtn.setImage(img, for: .normal)
           // mCardImgV.image = img
        }
        if let title = item.title {
           // mCardImgV.isHidden = true
            mPaymentBtn.setTitle(title, for: .normal)
        }
    }
    
    
    @objc func pressedPayment(sender: UIButton) {
        sender.removeCAShapeLayer()
        sender.backgroundColor = color_menu!
        sender.layer.cornerRadius = 5
       // self.bringSubviewToFront(mCardImgV)

        self.didPressPayment?(PaymentType(rawValue: sender.tag)!)
    }

}
