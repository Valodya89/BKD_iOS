//
//  MarkerInfoViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-05-21.
//

import UIKit
protocol MarkerInfoViewControllerDelegate: AnyObject {
    func didPressUserLocation()
    func didPressDeleteLocation()
    func didPressContinue(place: String, price: Double?)

}
class MarkerInfoViewController: UIViewController, StoryboardInitializable {
    
//MARK: Outlet
    @IBOutlet weak var mUserLocationBtn: UIButton!
    @IBOutlet weak var mDeleteAddressBtn: UIButton!
    @IBOutlet weak var mUserAddressLb: UILabel!
    @IBOutlet weak var mRentalAddres: UILabel!
    @IBOutlet weak var mErrorLb: UILabel!
    @IBOutlet weak var mBackgroundV: UIView!
    
    @IBOutlet weak var mServiceFeeLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mValueBackgV: UIView!
    @IBOutlet weak var mContinueBtn: UIButton!
    
    @IBOutlet weak var mContinueLeading: NSLayoutConstraint!
    @IBOutlet weak var mContinueBackgV: UIView!
    @IBOutlet weak var mContinueBottom: NSLayoutConstraint!
    
    //MARK: Variables
    weak var delegate: MarkerInfoViewControllerDelegate?
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView()  {
        mBackgroundV.layer.cornerRadius = 20
        mContinueBtn.layer.cornerRadius = 7
        mContinueBtn.setBorder(color: color_navigationBar!, width: 1)
        
    }
    private func clickContinue() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = self.mContinueBackgV.bounds.width - self.mContinueBtn.frame.size.width
            self.view.layoutIfNeeded()
        } completion: { [self] _ in
            self.delegate?.didPressContinue(place: mUserAddressLb.text ?? "", price: Double(mPriceLb.text ?? "0.0"))
        }
    }
  
    // MARK: - ACTIONS

    @IBAction func userLocation(_ sender: UIButton) {
        delegate?.didPressUserLocation()

    }
    
    @IBAction func deletAddress(_ sender: UIButton) {
        sender.isHidden = true
        mErrorLb.isHidden = true
        mUserAddressLb.text = ""        
        mUserAddressLb.textColor = color_navigationBar
        mContinueBackgV.isUserInteractionEnabled = false
        mContinueBackgV.alpha = 0.8
        UIView.animate(withDuration: 0.5) { [self] in
            self.mContinueLeading.constant = 0.0
            self.view.layoutIfNeeded()
    }
        delegate?.didPressDeleteLocation()
}
    
    @IBAction func clickContinue(_ sender: UIButton) {
        clickContinue()
    }

    @IBAction func continueSwipe(_ sender: UISwipeGestureRecognizer) {
        clickContinue()
    }
}
