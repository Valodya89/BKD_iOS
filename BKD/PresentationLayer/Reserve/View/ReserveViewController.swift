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
    @IBOutlet weak var mTowBarBckgV: UIView!
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
    @IBOutlet weak var mPriceTableV: PriceTableView!
    
    @IBOutlet weak var mPriceTableHeight: NSLayoutConstraint!
    var reserveViewModel = ReserveViewModel()
    public var vehicleModel: VehicleModel?
    var lastContentOffset:CGFloat = 0.0
    var totalPrice: Double = 0.0
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mReserveTableHeight.constant = mReserveInfoTableV.contentSize.height
        mPriceTableHeight.constant = mPriceTableV.contentSize.height
    }
    
    func setupView() {
        mRightBarBtn.image = img_bkd
        mConfirmBtn.layer.cornerRadius = 10
        mConfirmBtn.addBorder(color: color_navigationBar!, width: 1)
        mTotalPriceBackgV.layer.cornerRadius = 3
        mTotalPriceBackgV.setShadow(color: color_shadow!)
        mRentInfoBckgV.setShadow(color: color_shadow!)
        mCarImgBckgV.layer.cornerRadius = 16
        mCarImgBckgV.setShadow(color: color_shadow!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mScrollV.delegate = self
        
        configureView()
    }
    
    func clickConfirm() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.mConfirmLeading.constant = self.mConfirmBckgV.bounds.width - self.mConfirmBtn.frame.size.width
            self.mConfirmBckgV.layoutIfNeeded()

        } completion: { _ in

        }
    }
    
    func configureView() {
        
        mCarImgV.image = vehicleModel?.vehicleImg?.resizeImage(targetSize: CGSize(width:self.view.bounds.width * 0.729, height:self.view.bounds.height * 0.173))

        mCarDescriptionlb.text = vehicleModel?.vehicleDesctiption
        mTowBarBckgV.isHidden = !((vehicleModel?.ifHasTowBar) == true)
        mPickUpParkingLb.text = vehicleModel?.searchModel?.pickUpLocation
        mReturnParkingLb.text = vehicleModel?.searchModel?.returnLocation
        mPickUpDateLb.text = String((vehicleModel?.searchModel?.pickUpDate?.get(.day))!)
        mReturnDateLb.text = String((vehicleModel?.searchModel?.returnDate?.get(.day))!)
        mPickUpMonthLb.text = String((vehicleModel?.searchModel?.pickUpDate?.getMonth(lng: "en"))!)
        mReturnMonthLb.text = String((vehicleModel?.searchModel?.returnDate?.getMonth(lng: "en"))!)
        mPickUpTimeLb.text = vehicleModel?.searchModel?.pickUpTime?.getHour()
        mReturnTimeLb.text = vehicleModel?.searchModel?.returnTime?.getHour()
        
        self.mReserveInfoTableV.accessories = reserveViewModel.getAdditionalAccessories(vehicleModel: vehicleModel!) as? [AccessoriesModel]
        self.mReserveInfoTableV.drivers = reserveViewModel.getAdditionalDrivers(vehicleModel: vehicleModel!) as? [MyDriversModel]
        mReserveInfoTableV.reloadData()
        
        mPriceTableV.pricesArr = reserveViewModel.getPrices(vehicleModel: vehicleModel!) as! [PriceModel]
        mPriceTableV.reloadData()

        
        totalPrice = reserveViewModel.getTotalPrice(totalPrices: mPriceTableV.pricesArr)
        mTotalPriceValueLb.text = String(format: "%.2f",totalPrice)
        
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
