//
//  TariffCarouselCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-06-21.
//

import UIKit
protocol TariffCarouselCellDelegate: AnyObject {
    func didPressMore(tariffIndex: Int, optionIndex: Int)
    func didPressFuelConsuption(isCheck: Bool)
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
    
    @IBOutlet weak var mFlexibleFuelCheckBoxBtn: UIButton!
    //flexible
    
    @IBOutlet weak var mFlexiblestatv: UIStackView!
    
    //MARK: Variable
    var selectedSegmentIndex = 0
    var isConfirm = false
    var item: TariffSlideModel?
    weak var delegate: TariffCarouselCellDelegate?
    
    var segmentControl: UISegmentedControl?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed(Constant.NibNames.tariffCarousel, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
    func setUpView() {
        self.mSelectedBckgV.layer.cornerRadius = 5
        self.mUnselectedBckgV.layer.cornerRadius = 5
        mMoreBtn.layer.cornerRadius = 4
        mMoreBtn.setBorder(color: color_menu!, width: 0.7)
        mKwImgV.setTintColor(color: color_main!.withAlphaComponent(0.49))
        mUnselectedTitleLb.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }
    
    
    ///Configure segment control
    func configureSegmentControl() {
        
        let currTariffs = item?.tariff
        var segmentControlItems:[String] = []
        
        if currTariffs?.count ?? 0 > 0  {
            for i in (0..<Int(currTariffs!.count)) {
                let tariff:Tariff = currTariffs![i]
                
                if tariff.type == Constant.Keys.hourly {
                    segmentControlItems.append(String(Int(tariff.duration)) + Constant.Texts.h)
                } else if tariff.type == Constant.Keys.daily {
                    segmentControlItems.append(String(Int(tariff.duration)) + Constant.Texts.d)
                } else if tariff.type == Constant.Keys.weekly {
                    segmentControlItems.append(String(Int(tariff.duration)) + Constant.Texts.w)
                } else if tariff.type == Constant.Keys.monthly {
                    segmentControlItems.append(String(Int(tariff.duration)) + Constant.Texts.m)
                }
            }
            
            if  segmentControlItems.count > 0 {
            segmentControl = UISegmentedControl(items: segmentControlItems)
                segmentControl?.frame =  CGRect(x: mHoursSegmentC.frame.origin.x, y: mHoursSegmentC.frame.origin.y,  width:CGFloat(segmentControlItems.count * 31), height: mHoursSegmentC.frame.size.height)
                self.addSubview(segmentControl ?? UISegmentedControl())
            segmentControl?.selectedSegmentIndex = selectedSegmentIndex
            segmentControl?.addTarget(self, action: #selector(didChangeSegment(sender:)), for: .allEvents)
                }
        }
    }
    

    
    ///set info to close cells
    func setUnselectedCellsInfo(item:TariffSlideModel, index: Int) {
        mUnselectedBckgV.isHidden = false
        mSelectedBckgV.isHidden = true
        mUnselectedBckgV.backgroundColor = item.bckgColor!.withAlphaComponent(0.6)
        mUnselectedTitleLb.text = item.type
        mUnselectedTitleLb.textColor = index % 2 == 1 ? color_main : .white
    }
    
    /// set info to open cell 
    func setSelectedCellInfo(item:TariffSlideModel, index: Int)  {
        updateFuelConsumptionCheckBox(isSelected: item.fuelConsumption)
        mMoreBtn.tag = index
        mUnselectedBckgV.isHidden = true
        mSelectedBckgV.isHidden = false
        mTitleLb.text = item.type
        if let value = item.value {
            mPriceLb.text = value
        }
        if let options = item.options {
            mPriceLb.text = options[selectedSegmentIndex].value
    }
        mSelectedBckgV.backgroundColor = item.bckgColor
                   
        mKwLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mDepositLb.textColor = index % 2 == 1 ? color_main : color_entered_date
        mFuelConsumptionLb.textColor = index % 2 == 1 ? color_main : color_entered_date

        if index == 0 { //Hourly cell
            setHourlyCellInfo()
        } else {
            configureCommonCells(index: index)
        }
        if index == 4 || index == 0 { //hourly or Flexible cells
            configureHourlyAndFlexibleCells(index: index)
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
         mMoreBtn.setTitleColor(.white, for: .normal)

         configureSegmentControl()
         segmentControl?.backgroundColor = color_main!.withAlphaComponent(0.26)
         segmentControl?.setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: 15)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color_menu!], for: .selected)
         if #available(iOS 13.0, *) {
             segmentControl?.selectedSegmentTintColor = .white.withAlphaComponent(0.1)
         } else {
             // Fallback on earlier versions
         }

    }
    
    ///configure Flexible Cell
     func configureFlexibleCell() {
      
        
        mStartingPriceLb.isHidden = false
        mHoursSegmentC.isHidden = true
        mPriceCenterX.constant = 45
        mPriceCenterY.constant = 20
        mDetailsCenterY.constant = 52
         
         mFlexibleFuelCheckBoxBtn.isHidden = false
         mFlexibleFuelCheckBoxBtn.setTitle("", for: .normal)
         mDepositLb.text = Constant.Texts.fuelConsumption
         mFuelConsumptionLb.text = Constant.Texts.depositApplies
         mDepositImgV.image = UIImage(named: "12")
         mFuelConsumptionImgV.image = UIImage(named: "13")
         mFuelConsumptionLb.font = font_alert_title
         mKwLb.font = font_alert_title
         
         mConfirmBtn.setTitle(Constant.Texts.select, for: .normal)
         mKwImgV.setTintColor(color: .white.withAlphaComponent(0.6))
         mDepositImgV.setTintColor(color: UIColor(ciColor: .white).withAlphaComponent(0.49))
         mFuelConsumptionImgV.setTintColor(color: .white)
         mTitleLb.textColor = .white

    }
    
    ///configure cells which has common style
   func configureCommonCells(index: Int) {
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
        
        //segmentControl
       configureSegmentControl()
       
       segmentControl?.setBorder(color: index == 1 ? .white : .clear, width: 0.5)
         if #available(iOS 13.0, *) {
             segmentControl?.selectedSegmentTintColor = index == 2 ? color_main! : color_menu!
         } else {
             // Fallback on earlier versions
         }
      
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: index == 2 ? color_menu! : color_main!], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: index == 2 ? .white : color_main!], for: .selected)
      
       if index == 3 {
           segmentControl?.backgroundColor = .white.withAlphaComponent(0.49)
           segmentControl?.setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 0.01, height: 1)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
       } else {
           segmentControl?.backgroundColor = index == 2 ? color_main!.withAlphaComponent(0.26) : UIColor(ciColor: .white).withAlphaComponent(0.49)
           segmentControl?.setDividerImage(UIImage().colored(with: index == 1 ? color_segment_separator! : .clear, size: CGSize(width: 1, height: 15)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
       }
            
   }
    
    ///configure Hourly And Flexible Cells
    func configureHourlyAndFlexibleCells(index: Int) {
        mPriceLb.textColor = .white
        mEuroLb.textColor = .white
        mVatLb.textColor = .white
    
        if index == 4 { // Flexible
            configureFlexibleCell()
        }
        
    }
    
    ///Update FuelConsumption CheckBox button
    func updateFuelConsumptionCheckBox(isSelected: Bool) {
        if isSelected {
            mFlexibleFuelCheckBoxBtn.setImage(img_check_box, for: .normal)
        } else {
            mFlexibleFuelCheckBoxBtn.setImage(img_uncheck_box, for: .normal)
        }
    }
    
    @objc func didChangeSegment(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        if isConfirm {
            delegate?.willChangeOption(optionIndex: selectedSegmentIndex)
        }
        guard let options = item?.options  else {return}
        if selectedSegmentIndex < item?.tariff?.count ?? 0 {
        mPriceLb.text = options[selectedSegmentIndex].value
        }

    }
    
    //MARK: ACTIONS
    //MARK: --------------------
    @IBAction func flexibleFuelCheckBox(_ sender: UIButton) {
        if sender.image(for: .normal) == img_check_box  {
            mDepositLb.font = font_bot_placeholder
            sender.setImage(img_uncheck_box, for: .normal)
            delegate?.didPressFuelConsuption(isCheck: false)
        } else {
            mDepositLb.font = font_alert_title
            sender.setImage(img_check_box, for: .normal)
            delegate?.didPressFuelConsuption(isCheck: true)
        }
    }
    
    
    @IBAction func more(_ sender: UIButton) {
        delegate?.didPressMore(tariffIndex: sender.tag,
                               optionIndex: selectedSegmentIndex)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        if !isConfirm {
            isConfirm = true
            sender.setTitleColor(mTitleLb.text == Constant.Texts.daily ? .white : color_menu, for: .normal)
            delegate?.showSearchView(optionIndex: selectedSegmentIndex)
        }
    }
    
    @IBAction func hours(_ sender: UISegmentedControl) {
        
    }
    
    
}
