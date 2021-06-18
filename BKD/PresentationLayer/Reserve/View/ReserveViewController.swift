//
//  ReserveViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 17-06-21.
//

import UIKit

class ReserveViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var mCarBckgV: UIView!
    @IBOutlet weak var mTowBarLb: UILabel!
    @IBOutlet weak var mTowBarBtn: UIButton!
    @IBOutlet weak var mCarImgV: UIImageView!
    
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
    
    @IBOutlet weak var mAdditionalDriveAndAccessoreTbV: UITableView!
    
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
    
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var mNavigationItem: UINavigationItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
    }
//MARK: ACTIONS
//MARK: ----------
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
