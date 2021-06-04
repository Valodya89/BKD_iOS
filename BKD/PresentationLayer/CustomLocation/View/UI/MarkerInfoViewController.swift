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
    
    @IBOutlet weak var mLeftContinueBtn: UIButton!
    @IBOutlet weak var mRightContinueBtn: UIButton!
    @IBOutlet weak var mSearchBackgV: UIView!
    @IBOutlet weak var mSearchBottom: NSLayoutConstraint!
    
    //MARK: Variables
    weak var delegate: MarkerInfoViewControllerDelegate?
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView()  {
        mBackgroundV.layer.cornerRadius = 20
        mLeftContinueBtn.layer.cornerRadius = 7
        mRightContinueBtn.layer.cornerRadius = 7
        mLeftContinueBtn.setBorder(color: color_navigationBar!, width: 1)
        mRightContinueBtn.setBorder(color: color_navigationBar!, width: 1)
//        mValueBackgV.setGradient(startColor:color_gradient_end!, endColor: color_gradient_start!)
        
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
        mSearchBackgV.isUserInteractionEnabled = false
        mSearchBackgV.alpha = 0.8
        delegate?.didPressDeleteLocation()

    }
    
    @IBAction func leftContinue(_ sender: UIButton) {
        sender.isHidden = true
        mRightContinueBtn.isHidden = false
    }
    @IBAction func rightContinue(_ sender: UIButton) {
        sender.isHidden = true
        mLeftContinueBtn.isHidden = false
    }
}
