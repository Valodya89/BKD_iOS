//
//  PaymenTypeTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

enum PaymentType: Int {
    case bancontact
    case applePay
    case payPal
    case creditCard


}
import UIKit

class PaymenTypeTableViewCell: UITableViewCell {
static let identifier = "PaymenTypeTableViewCell"
    
    @IBOutlet weak var mPaymentBtn: UIButton!
    @IBOutlet weak var mCardImgV: UIImageView!
    
    var didPressPayment:((PaymentType, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func draw(_ rect: CGRect) {
        setUpView()
    }
    
    func setUpView() {
        mPaymentBtn.backgroundColor = .clear
//        mPaymentBtn.layer.cornerRadius = 5
//        mPaymentBtn.layer.borderWidth = 1
//        mPaymentBtn.layer.borderColor = color_navigationBar!.cgColor

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
            mPaymentBtn.setTitle("", for: .normal)
            mPaymentBtn.setImage(img, for: .normal)
            mCardImgV.image = img
        }
        if let title = item.title {
            mPaymentBtn.setTitle(title, for: .normal)
        }
        if item.isClicked {
           
            didTouchCell()
        } else {
            mCardImgV.isHidden = true
            mPaymentBtn.removeCAShapeLayer()
            mPaymentBtn.roundCornersWithBorder(corners: .allCorners, radius: 5, borderColor: color_navigationBar!, borderWidth: 1)
        }
    }
    
    private func didTouchCell() {
        mCardImgV.isHidden = false
//        mPaymentBtn.removeCAShapeLayer()
//        mPaymentBtn.roundCornersWithBorder(corners: .allCorners, radius: 5, borderColor: color_menu!, borderWidth: 1)
        DispatchQueue.main.async {
            self.mPaymentBtn.setBackgroundColorToCAShapeLayer(color: color_menu!)
            self.mPaymentBtn.setBorderColorToCAShapeLayer(color: color_menu!)
        }
        
    }
    
    @objc func pressedPayment(sender: UIButton) {
        
        self.didPressPayment?(PaymentType(rawValue: sender.tag)!,
                              sender.tag)
        
    }

}
