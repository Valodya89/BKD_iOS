//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class ReserveViewController: UIViewController {
    //MARK: Outlet
    //Car
    @IBOutlet weak var mCarBckgV: UIView!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mTowBarBtn: UIButton!
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mCarImgBckgV: UIView!
    @IBOutlet weak var mCarAnimationV: UIView!
    
    @IBOutlet weak var mCarHeight: NSLayoutConstraint!
    @IBOutlet weak var mCarWidth: NSLayoutConstraint!
    @IBOutlet weak var mCarCenterX: NSLayoutConstraint!
    @IBOutlet weak var mCarCenterY: NSLayoutConstraint!
    
    
    @IBOutlet weak var mCarMarkBckgV: UIView!
    @IBOutlet weak var mFiatImgV: UIImageView!
    @IBOutlet weak var mCarDescriptionlb: UILabel!
    @IBOutlet weak var mCarMarkLb: UILabel!
    
   //PickUP
    @IBOutlet weak var mPickUpLb: UILabel!
    @IBOutlet weak var mRentLb: UILabel!
    @IBOutlet weak var mRentInfoBckgV: UIView!
    @IBOutlet weak var mPickUpParkingLb: UILabel!
    @IBOutlet weak var mPickUpDateLb: UILabel!
    @IBOutlet weak var mPickUpMonthLb: UILabel!
    @IBOutlet weak var mPickUpTimeLb: UILabel!
    
 //return
    @IBOutlet weak var mReturnParkingLb: UILabel!
    @IBOutlet weak var mReturnDateLb: UILabel!
    @IBOutlet weak var mReturnMonthLb: UILabel!
    @IBOutlet weak var mReturnTimeLb: UILabel!
        
    //price list
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mPriceValueLb: UILabel!
    @IBOutlet weak var mSpecialOfferValueLb: UILabel!
    @IBOutlet weak var mSpecialOfferLb: UILabel!
        @IBOutlet weak var mDisacountValueLb: UILabel!
    @IBOutlet weak var mCustomLocationLb: UILabel!
    @IBOutlet weak var mCustomLocationValueLb: UILabel!
    @IBOutlet weak var mAccessoriesLb: UILabel!
    @IBOutlet weak var mAccessoriecValueLb: UILabel!
    @IBOutlet weak var mAdditionalDriverLb: UILabel!
    @IBOutlet weak var mAdditionalDriverValueLb: UILabel!
    
   //Total Price
    @IBOutlet weak var mTotalPriceBackgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mTotalPriceValueLb: UILabel!
    
   //Confirm
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    @IBOutlet var mConfirmSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var mConfirmLeading: NSLayoutConstraint!
    
    //Navigation
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mNavigationItem: UINavigationItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mReserveInfoTableV: ReserveTableView!
    @IBOutlet weak var mReserveTableHeight: NSLayoutConstraint!
    
    var lastContentOffset:CGFloat = 0.0
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height

    }
    
    func setupView() {
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mTotalPriceBackgV.setShadow(color: color_shadow!)
        mTotalPriceBackgV.layer.cornerRadius = 3
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mCarImgBckgV.layer.cornerRadius = 16
        mCarImgBckgV.setShadow(color: color_shadow!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mScrollV.delegate = self
    }
    
    func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()

        } completion: { _ in

        }
    }
//MARK: ACTIONS
//MARK: ----------
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        clickConfirm()
    }
    
    @IBAction func confirmSwipe(_ sender: UISwipeGestureRecognizer) {
        clickConfirm()
    }

}

extension ReserveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
                print("up \(mCarHeight.constant)")
            if mCarHeight.constant <= 0 {
                mCarHeight.constant += 1
                mCarWidth.constant += 2.3
                mCarCenterX.constant -= 1.5
                mCarCenterY.constant += 0.5
            }
            
            } else {
                print("down \(mCarHeight.constant)")
                if mCarHeight.constant >= -100 {
                    mCarHeight.constant -= 1
                    mCarWidth.constant -= 2.3
                    mCarCenterX.constant += 1.5
                    mCarCenterY.constant -= 0.5
                }
           }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
                print("up \(mCarHeight.constant)")
            UIView.animate(withDuration: 0.8) { [self] in
                self.mCarHeight.constant = 0
                self.mCarWidth.constant = 0
                self.mCarCenterX.constant = 0
                self.mCarCenterY.constant = 0
            }
                
            
            }
        else {
                print("down \(mCarHeight.constant)")
                UIView.animate(withDuration: 0.8) {
                    self.mCarHeight.constant = -100
                    self.mCarWidth.constant = -230
                    self.mCarCenterX.constant = 150
                    self.mCarCenterY.constant = -50
                }
           }
    }
}
