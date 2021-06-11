//
//  DetailAndTailLiftView.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-06-21.
//

import UIKit

enum CurrentOpenList {
    case details
    case tailLift
}
protocol DetailsAndTailLiftViewDelegate: AnyObject {
    func didPressDetails(willOpen: Bool)
    func didPressTailLift(willOpen: Bool)

}

class DetailsAndTailLiftView: UIView {
 //MARK: Outlates
    @IBOutlet weak var mDetailsBtn: UIButton!
    @IBOutlet weak var mTailLiftBtn: UIButton!
    @IBOutlet weak var mDetailsDropDownImgV: UIImageView!
    @IBOutlet weak var mTailLiftDropDownImgV: UIImageView!

    //MARK: Variables
    var currentOpenList: CurrentOpenList?
    weak var delegate: DetailsAndTailLiftViewDelegate?
    
    var isDetail = false
    var isTailLift = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setShadow(color: color_shadow!)
        self.setBorder(color: color_shadow!, width: 0.25)
        self.layer.cornerRadius = 3
    }
    
    //MARK: ACTIONS
    //MARK: --------------------
    
    @IBAction func details(_ sender: UIButton) {
        if !isDetail {
            delegate?.didPressDetails(willOpen: true)
        } else {
            delegate?.didPressDetails(willOpen: false)
        }
        isDetail = !isDetail
        isTailLift = false
    }
    
    @IBAction func tailLift(_ sender: UIButton) {
        if !isTailLift {
            mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
            delegate?.didPressTailLift(willOpen: true)
        } else {
            mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            delegate?.didPressTailLift(willOpen: false)
        }
        
        isTailLift = !isTailLift
        isDetail = false
        mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
   }
}
