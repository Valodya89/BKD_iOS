//
//  TariffCarouselCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-06-21.
//

import UIKit
protocol TariffCarouselCellDelegate: AnyObject {
    func didPressMore()
    func showSearchView(optionIndex: Int)
    func willChangeOption(optionIndex: Int)

}

class TariffCarouselCell: UIView {
    //MARK: Outlates
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mMoreBtn: UIButton!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mEuroLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mVatLb: UILabel!
    @IBOutlet weak var mKwImgV: UIImageView!
    @IBOutlet weak var mFuelConsumptionImgV: UIImageView!
    @IBOutlet weak var mFuelConsumptionLb: UILabel!
    @IBOutlet weak var mDepositImgV: UIImageView!
    @IBOutlet weak var mKwLb: UILabel!
    @IBOutlet weak var mDepositLb: UILabel!
    @IBOutlet weak var mConfirmBckgV: UIView!
    @IBOutlet weak var mConfirmBtn: UIButton!
    
    @IBOutlet weak var mHoursSegmentC: UISegmentedControl!
    @IBOutlet weak var mWeeklySegmentC: UISegmentedControl!
    @IBOutlet weak var mUnselectedBckgV: UIView!
    @IBOutlet weak var mSelectedBckgV: UIView!
    @IBOutlet weak var mUnselectedTitleLb: UILabel!
    @IBOutlet weak var mMonthlyBtn: UIButton!
    @IBOutlet weak var mStartingPriceLb: UILabel!
    @IBOutlet weak var mPriceDeleteLineV: UIView!
    
    //Offert Price
    @IBOutlet weak var mOffertPriceBckgV: UIView!
    @IBOutlet weak var mOffertEuroLb: UILabel!
    @IBOutlet weak var mOffertVatLb: UILabel!
    @IBOutlet weak var mOffertPriceLb: UILabel!
    
    //NSLayoutConstraints
    @IBOutlet weak var mPriceCenterX: NSLayoutConstraint!
    @IBOutlet weak var mDetailsCenterY: NSLayoutConstraint!
    @IBOutlet weak var mPriceCenterY: NSLayoutConstraint!
    
    //MARK: Variable
    var selectedSegmentIndex = 0
    var isConfirm = false
    weak var delegate: TariffCarouselCellDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {       Bundle.main.loadNibNamed(Constant.NibNames.tariffCarousel, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
    func setUpView() {
        self.mSelectedBckgV.layer.cornerRadius = 5
        self.mUnselectedBckgV.layer.cornerRadius = 5
        mMoreBtn.layer.cornerRadius = 4
        mMonthlyBtn.layer.cornerRadius = 9
        mMoreBtn.setBorder(color: color_menu!, width: 0.7)
        mKwImgV.setTintColor(color: color_main!.withAlphaComponent(0.49))
        mUnselectedTitleLb.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        mHoursSegmentC.isHidden = false

    }
    
    ///Set segments to segment control
    func setSegmentControlSegment(index: Int, segmentC: UISegmentedControl) {
        let currOptions = tariffOptionsArr[index]
        if currOptions.count > 0  {
            for i in (0..<Int(currOptions.count)) {
                segmentC.setTitle(currOptions[i], forSegmentAt: i)
            }
            segmentC.selectedSegmentIndex = selectedSegmentIndex
            segmentC.addTarget(self, action: #selector(didChangeSegment(sender:)), for: .allEvents)
        }
    }
    
    
    ///set info to close cells
    func setUnselectedCellsInfo(item:TariffSlideModel, index: Int) {
        mUnselectedBckgV.isHidden = false
        mSelectedBckgV.isHidden = true
        mUnselectedBckgV.backgroundColor = item.bckgColor.withAlphaComponent(0.6)
        mUnselectedTitleLb.text = item.title
        mUnselectedTitleLb.textColor = index % 2 == 1 ? color_main : .white
    }
    
    /// set info to open cell 
    func setSelectedCellInfo(item:TariffSlideModel, index: Int)  {
        mUnselectedBckgV.isHidden = true
        mSelectedBckgV.isHidden = false
        mTitleLb.text = item.title
        mPriceLb.text = "99,9"
        mSelectedBckgV.backgroundColor = item.bckgColor
                   
        mKwLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mDepositLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mFuelConsumptionLb.textColor = index % 2 == 1 ? color_main : color_entered_date

        if index == 0 { //Hourly cell
            setHourlyCellInfo()
        } else {
            setCommonCellsInfo(index: index)
        }
        if index == 4 || index == 0 { //hourly or Flexible cells
            setHourlyAndFlexibleCellsCommonInfo(index: index)
        }
    }
    
    ///set hourly cell info
     func setHourlyCellInfo() {
        // will check if it dark mode or not
        if self.traitCollection.userInterfaceStyle == .light {
            mConfirmBckgV.setGradient(startColor:color_Offline_bckg!.withAlphaComponent(0.2), endColor:color_Offline_bckg!.withAlphaComponent(0.7))
            mConfirmBtn.setTitleColor(.white, for: .normal)
        } else {
            mConfirmBckgV.backgroundColor =  UIColor(ciColor: .white).withAlphaComponent(0.25)
            mConfirmBtn.setTitleColor(color_main!, for: .normal)
        }
        setSegmentControlSegment(index: 0, segmentC: mHoursSegmentC)
        mHoursSegmentC.backgroundColor = color_main!.withAlphaComponent(0.26)
//        mHoursSegmentC.addTarget(self, action: #selector(didChangeSegment(sender:)), for: .allEvents)
        mMoreBtn.setTitleColor(.white, for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color_menu!], for: .selected)
    }
    
    ///set info to the Flexible Cell
     func setFlexibleCellInfo() {
        mConfirmBtn.setTitle("Select", for: .normal)
        mKwImgV.setTintColor(color: .white)
        mDepositImgV.setTintColor(color: UIColor(ciColor: .white).withAlphaComponent(0.49))
        mFuelConsumptionImgV.setTintColor(color: .white)
        mTitleLb.textColor = .white
        
        mStartingPriceLb.isHidden = false
        mHoursSegmentC.isHidden = true
        mPriceCenterX.constant = 45
        mPriceCenterY.constant = 20
        mDetailsCenterY.constant = 52

    }
    
    ///set info to cells which have common design
   func setCommonCellsInfo(index: Int) {
        mConfirmBckgV.backgroundColor = UIColor(ciColor: .white).withAlphaComponent(0.25)
        
      //UILables
        mPriceLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mEuroLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mVatLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mTitleLb.textColor = index == 2 ?  color_weekly : color_main
        
        //UIButtons
        mConfirmBtn.setTitleColor(index == 2 ? color_alert_txt! : color_main, for: .normal)
        mMoreBtn.setTitleColor(color_main, for: .normal)

        mMoreBtn.backgroundColor = UIColor(ciColor: .white).withAlphaComponent(0.4)
        mMoreBtn.layer.borderColor = index == 2 ? color_weekly!.cgColor : color_main!.cgColor
        
        //segmentControll
    
        setSegmentControlSegment(index: index, segmentC: mHoursSegmentC)
        mHoursSegmentC.backgroundColor = UIColor(ciColor: .white).withAlphaComponent(0.49)
        mHoursSegmentC.setBorder(color: index == 1 ? .white : .clear, width: 0.5)
        if #available(iOS 13.0, *) {
            mHoursSegmentC.selectedSegmentTintColor = color_menu!
        } else {
            // Fallback on earlier versions
        }
        mWeeklySegmentC.backgroundColor  = color_main!.withAlphaComponent(0.26)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: index == 2 ? color_menu! : color_main!], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: index == 2 ? .white : color_main!], for: .selected)
        mHoursSegmentC.setDividerImage(UIImage().colored(with: color_segment_separator!, size: CGSize(width: 1, height: 15)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
    mWeeklySegmentC.isHidden = index == 2 ? false : true
    mHoursSegmentC.isHidden = index == 2 ? true : false
    if index == 2 {
        setSegmentControlSegment(index: index, segmentC: mWeeklySegmentC)
    }
    
    if index == 3 {
        mMonthlyBtn.isHidden = false
        mWeeklySegmentC.isHidden = true
        mHoursSegmentC.isHidden = true
    }
   }
    
    func setHourlyAndFlexibleCellsCommonInfo(index: Int) {
        mPriceLb.textColor = .white
        mEuroLb.textColor = .white
        mVatLb.textColor = .white
        mMonthlyBtn.isHidden = true
        mWeeklySegmentC.isHidden = true
        mHoursSegmentC.setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: 15)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        if index == 4 { // Flexible
            setFlexibleCellInfo()
        }
        
    }
    
    @objc func didChangeSegment(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        if isConfirm {
            delegate?.willChangeOption(optionIndex: selectedSegmentIndex)
        }
    }
    
    //MARK: ACTIONS
    //MARK: --------------------
    @IBAction func more(_ sender: UIButton) {
        delegate?.didPressMore()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        if !isConfirm {
            isConfirm = true
            sender.setTitleColor(color_menu, for: .normal)
            delegate?.showSearchView(optionIndex: selectedSegmentIndex)
        }
    }
    
    @IBAction func hours(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func monthly(_ sender: UIButton) {
    }
    
}
