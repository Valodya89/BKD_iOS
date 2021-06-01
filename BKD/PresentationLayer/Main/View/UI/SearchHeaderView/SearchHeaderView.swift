//
//  SearchHeaderView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-05-21.
//

import UIKit

class SearchHeaderView: UIView, UITextFieldDelegate {

    static let identifier = "SearchHeaderView"
    
    @IBOutlet weak var mPickUpDataTxtFl: TextField!
    @IBOutlet weak var mReturnDateTxtFl: TextField!
    @IBOutlet weak var carouselBackgV: CarouselView!
   
    @IBOutlet weak var mCheckBoxPickUpCustomLocBtn: UIButton!
    @IBOutlet weak var mCheckBoxReturnCustomLocBtn: UIButton!
    @IBOutlet weak var mReturnCustomLocationBtn: UIButton!
    @IBOutlet weak var mPickUpCustomLocationBtn: UIButton!
    
    @IBOutlet weak var mDayPickUpBtn: UIButton!
    @IBOutlet weak var mMonthPickUpBtn: UIButton!
    @IBOutlet weak var mDayReturnDateBtn: UIButton!
    @IBOutlet weak var mMonthReturnDateBtn: UIButton!
    
    
    @IBOutlet weak var mPickUpDateImgV: UIImageView!
    @IBOutlet weak var mReturnDateImgV: UIImageView!
    
    @IBOutlet weak var mPickUpTimeTxtFl: TextField!
    @IBOutlet weak var mReturnTimeTxtFl: TextField!
    @IBOutlet weak var mPickUpTimeBtn: UIButton!
    @IBOutlet weak var mReturnTimeBtn: UIButton!
    @IBOutlet weak var mReturnTimeImgV: UIImageView!
    @IBOutlet weak var mPickUpTimeImgV: UIImageView!
    @IBOutlet weak var mPickUpTimeDropImgV: UIImageView!
    @IBOutlet weak var mReturnDropImgV: UIImageView!
    
    @IBOutlet weak var mPickUpLocationBtn: UIButton!
    @IBOutlet weak var mReturnLocationBtn: UIButton!
    @IBOutlet weak var mSearchLeftBtn: UIButton!
    
    @IBOutlet weak var mSearchBckgV: UIView!
    @IBOutlet weak var mSearchRightImgV: UIImageView!
    @IBOutlet weak var mSearchLeftImgV: UIImageView!
    @IBOutlet weak var mSearchRightBtn: UIButton!
    @IBOutlet weak var mDateLb: UILabel!
    @IBOutlet weak var mTimeLb: UILabel!
    @IBOutlet weak var mLocationLb: UILabel!
    @IBOutlet weak var mErrorMessageLb: UILabel!
    @IBOutlet weak var mArrowBtn: UIButton!
    @IBOutlet weak var mLocationDropDownView: LocationDropDownView!
    @IBOutlet var contentView: UIView!
    
    var pickUPDropisClose: Bool = true
    var returnDropisClose: Bool = true
    var currLocationBtn = UIButton()
    var currLocationDropImgV = UIImageView()
    
    let searchHeaderViewModel: SearchHeaderViewModel = SearchHeaderViewModel()
    

    var didSelectPickUp: ((UITextField) -> Void)?
    var didSelectSearch: (() -> Void)?
    var didSelectLocation: ((String, Int) -> Void)?
    var didSelectCustomLocation: ((UIButton, Bool) -> Void)?
    var hideEditView: (() -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed(Constant.NibNames.SearchHeaderView, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
        
    func setUpView() {
        setBorder()
        mPickUpDataTxtFl.delegate = self
        mReturnDateTxtFl.delegate = self
        mPickUpTimeTxtFl.delegate = self
        mReturnTimeTxtFl.delegate = self
        mPickUpDataTxtFl.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        mDayPickUpBtn.isHidden = true
        mMonthPickUpBtn.isHidden = true
        mPickUpDataTxtFl.text = "Pick Up Date"
        mDayReturnDateBtn.isHidden = true
        mMonthReturnDateBtn.isHidden = true
        mReturnDateTxtFl.text = "Return Date"
        mReturnTimeTxtFl.textColor = UIColor(named: "choose_date")
        mPickUpTimeTxtFl.textColor = UIColor(named: "choose_date")
        mPickUpLocationBtn.tintColor = UIColor(named: "choose_date")
        mReturnLocationBtn.tintColor = UIColor(named: "choose_date")

        
        mSearchBckgV.layer.cornerRadius = 8
        mSearchLeftBtn.layer.cornerRadius = 8
        mSearchRightBtn.layer.cornerRadius = 8
        // border
        mLocationDropDownView.clipsToBounds = true
        mLocationDropDownView.layer.borderWidth = 0.3
        mLocationDropDownView.layer.borderColor = UIColor(named: "gradient_end")?.cgColor
      
        
        mLocationDropDownView.hiddenLocationList = { [weak self] in
            self?.hiddenLocationList()
            self?.mLocationDropDownView.layer.shadowOpacity = 0;

        }
        
        mLocationDropDownView.didSelectLocation = { [weak self] txt in
            self?.didSelectLocation?(txt, (self?.currLocationBtn.tag)!)
            self?.currLocationBtn.setTitle(txt, for: .normal)
            self?.currLocationBtn.titleLabel!.font = font_selected_filter
            self?.currLocationBtn.setTitleColor(color_entered_date, for: .normal)
            self?.currLocationDropImgV.image = UIImage(named: "dropDown_blue")
            self?.currLocationBtn.tag == 4 ?  UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_pickUpLocation) :  UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_returnLocation)
            if self?.mErrorMessageLb.isHidden == false{
              let _ = self?.checkFieldsFilled()
            }
        }
    }
    
    func setBorder() {
        // textField border
        setTextFieldBorder(leftTextField: mPickUpDataTxtFl, rightTextField: mReturnDateTxtFl, color: color_navigationBar!)
        setTextFieldBorder(leftTextField: mPickUpTimeTxtFl, rightTextField: mReturnTimeTxtFl, color: color_navigationBar!)
        //botton border
        mPickUpLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mSearchLeftBtn.addBorder(color:color_navigationBar!, width: 1.0)
        mSearchRightBtn.addBorder(color: color_navigationBar!, width: 1.0)
    }
    
    func setTextFieldBorder(leftTextField: UITextField, rightTextField: UITextField, color: UIColor) {
        leftTextField.addBorder(side: .bottom, color: color, width: 1.0)
        leftTextField.addBorder(side: .left, color: color, width: 1.0)
        leftTextField.addBorder(side: .top, color: color, width: 1.0)
        rightTextField.addBorder(side: .bottom, color: color, width: 1.0)
        rightTextField.addBorder(side: .right, color: color, width: 1.0)
        rightTextField.addBorder(side: .top, color: color, width: 1.0)
    }
    
    func showLocationList() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.setShadow(color: UIColor(named: "gradient_end")!)
            self.mLocationDropDownView.mheightLayoutConst.constant = 164.0
            self.layoutIfNeeded()
        })
    }
    
    func hiddenLocationList() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.mheightLayoutConst.constant = 0.0
            self.mLocationLb.textColor = color_search_placeholder
            pickUPDropisClose = true
            self.layoutIfNeeded()
        })
    }
//MARK: VALIDATIONS
//MARK: ------------------
    
//check if all fields are filled
  func checkFieldsFilled()-> Bool{
        setBorder()
        searchHeaderViewModel.isFieldsFilled(pickUpDay: mDayPickUpBtn.titleLabel?.text,
                                             returnDay: mDayReturnDateBtn.titleLabel?.text,
                                             pickUpTime: mPickUpTimeTxtFl.text,
                                             returnTime: mReturnTimeTxtFl.text,
                                             pickUpLocation: mPickUpLocationBtn.title(for: .normal),
                                             returnLocation: mReturnLocationBtn.title(for: .normal)) { [self] ( validationType:[ValidationType] ) in
            for  validateResult in validationType {
                mErrorMessageLb.isHidden = false
                switch validateResult {
                    case .date:
                        setTextFieldBorder(leftTextField: mPickUpDataTxtFl, rightTextField: mReturnDateTxtFl, color: color_error!)
                    case .time:
                        setTextFieldBorder(leftTextField: mPickUpTimeTxtFl, rightTextField: mReturnTimeTxtFl, color: color_error!)
                    case .pickUplocation:
                        mPickUpLocationBtn.addBorder(color: color_error!, width: 1.0)
                    case .returnlocation:
                        mReturnLocationBtn.addBorder(color: color_error!, width: 1.0)
                    case .success:
                        mErrorMessageLb.isHidden = true
                }
            }
        }
    return mErrorMessageLb.isHidden
    }
    
   
    //MARK: SEARCH
    //MARK: ------------------

      @IBAction func searchLeft(_ sender: UIButton) {
        if checkFieldsFilled() {
            sender.isHidden = true
            mSearchRightBtn.isHidden = false
            didSelectSearch!()
        }
      }
    
    @IBAction func searchRight(_ sender: UIButton) {
        sender.isHidden = true
        mSearchLeftBtn.isHidden = false
        mErrorMessageLb.isHidden = true
        setBorder()

    }
    @IBAction func pickUpLocation(_ sender: UIButton) {
        mLocationDropDownView.mPickUpLocationTableView.reloadData()
        mReturnDropImgV.image = UIImage(named: "dropDown_blue")
       returnDropisClose = true
        currLocationBtn = sender
        currLocationDropImgV = mPickUpTimeDropImgV

        if pickUPDropisClose {
            mPickUpTimeDropImgV.image = UIImage(named: "dropUp_blue")
            showLocationList()
        } else {
            mPickUpTimeDropImgV.image = UIImage(named: "dropDown_blue")
            hiddenLocationList()
        }
        pickUPDropisClose = !pickUPDropisClose
    }
    
    @IBAction func returnLocation(_ sender: UIButton) {
       mLocationDropDownView.mPickUpLocationTableView.reloadData()

        mPickUpTimeDropImgV.image = UIImage(named: "dropDown_blue")
        pickUPDropisClose = true
        currLocationBtn = sender
        currLocationDropImgV = mReturnDropImgV
        if returnDropisClose {
            mReturnDropImgV.image = UIImage(named: "dropUp_blue")
            showLocationList()
        } else {
            mReturnDropImgV.image = UIImage(named: "dropDown_blue")
            hiddenLocationList()
        }
        returnDropisClose = !returnDropisClose
    }
    
//MARK: ACTIONS
//MARK: ------------------

    @IBAction func checkBoxPickUpCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
        } else {
            sender.setImage(img_check_box, for: .normal)
            let willShowLocationAlert: Bool = (mCheckBoxReturnCustomLocBtn.image(for: .normal) ==  img_check_box) ? false : true
                
            didSelectCustomLocation?(mCheckBoxPickUpCustomLocBtn, willShowLocationAlert)

        }
       
    }
    @IBAction func pickUpCustomLocation(_ sender: UIButton) {
       
        
    }
    @IBAction func checkBoxReturnCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
        } else {
            sender.setImage(img_check_box, for: .normal)
            let willShowLocationAlert: Bool = (mCheckBoxPickUpCustomLocBtn.image(for: .normal) ==  img_check_box) ? false : true
                
            didSelectCustomLocation?(mCheckBoxReturnCustomLocBtn, willShowLocationAlert)
        }
    }
    
    @IBAction func pickUp(_ sender: Any) {
        mPickUpDataTxtFl.becomeFirstResponder()
    }
    
    @IBAction func returnDate(_ sender: Any) {
        mReturnDateTxtFl.becomeFirstResponder()
    }
    @IBAction func pickUpTime(_ sender: Any) {
        mPickUpTimeTxtFl.becomeFirstResponder()
    }
    @IBAction func returnTime(_ sender: Any) {
        mReturnTimeTxtFl.becomeFirstResponder()
    }
    
    @IBAction func arrow(_ sender: UIButton) {
        hideEditView?()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didSelectPickUp?(textField)
        
    }

}
