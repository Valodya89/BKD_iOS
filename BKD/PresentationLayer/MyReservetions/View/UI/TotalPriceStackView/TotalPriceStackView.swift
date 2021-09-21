//
//  TotalPriceStackView.swift
//  TotalPriceStackView
//
//  Created by Karine Karapetyan on 15-09-21.
//

import UIKit

enum TotalPriceState {
    case oldTotalPrice
    case newTotalPrice
    case none
}

class TotalPriceStackView: UIStackView {

 //MARK: -- Outlets
    @IBOutlet weak var mOldTotalPriceContentV: UIView!
    @IBOutlet weak var mNewTotalPriceContentV: UIView!
    @IBOutlet weak var mOldTotalPriceTitleLb: UILabel!
    @IBOutlet weak var mNewTotalPriceTitleLb: UILabel!
    @IBOutlet weak var mOldTotalPriceLb: UILabel!
    @IBOutlet weak var mNewTotalPriceLb: UILabel!
    @IBOutlet weak var mOldTotalPriceDropDownImg: UIImageView!
    @IBOutlet weak var mNewTotalPriceDropDownImg: UIImageView!
    @IBOutlet weak var mOldTotalPriceBtn: UIButton!
    @IBOutlet weak var mNewTotalPriceBtn: UIButton!
    
    //MARK: Variables
    var isEdited: Bool = false
    var dropDownState: TotalPriceState = .none
    var willOpenNewTotalPrice: (() -> Void)?
    var willOpenOldTotalPrice: (() -> Void)?
    var willCloseNewTotalPrice: (() -> Void)?
    var willCloseOldTotalPrice: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        mOldTotalPriceContentV.layer.cornerRadius = 3
        mNewTotalPriceContentV.layer.cornerRadius = 3
        mOldTotalPriceContentV.setShadow(color: color_shadow!)
        mNewTotalPriceContentV.setShadow(color: color_shadow!)
        mNewTotalPriceBtn.setTitle("", for: .normal)
        if !isEdited {
            mOldTotalPriceContentV.isHidden = true
            mNewTotalPriceLb.text = Constant.Texts.totalPrice
        }
    }
    
    ///show old and new total price views
    func showOldAndNewTotalPrices(oldPrice: Double, newPrice: Double) {
        mOldTotalPriceContentV.isHidden = false
        mOldTotalPriceTitleLb.text = Constant.Texts.oldTotalPrice
        mNewTotalPriceTitleLb.text = Constant.Texts.newTotalPrice
        mOldTotalPriceLb.text = String(format: "%.2f",oldPrice)
        mNewTotalPriceLb.text = String(format: "%.2f",newPrice)
    }
    
    
    //MARK: -- Actions
    @IBAction func oldTotalPriceHandler(_ sender: UIButton) {
        if dropDownState == .newTotalPrice {
           mNewTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            willCloseNewTotalPrice?()
       }
        if dropDownState == .oldTotalPrice {
            mOldTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            dropDownState = .none
            willCloseOldTotalPrice?()
        }  else {
            willOpenOldTotalPrice?()
            dropDownState = .oldTotalPrice
            mOldTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi))
        }
    }
    

    @IBAction func newTotalPriceHandler(_ sender: Any) {
        if dropDownState == .oldTotalPrice {
            mOldTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            willCloseOldTotalPrice?()
        }
        if dropDownState == .newTotalPrice {
            mNewTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            dropDownState = .none
            willCloseNewTotalPrice?()

        }  else {
            willOpenNewTotalPrice?()
            dropDownState = .newTotalPrice
            mNewTotalPriceDropDownImg.rotateImage(rotationAngle: CGFloat(Double.pi))
        }
    }
}
