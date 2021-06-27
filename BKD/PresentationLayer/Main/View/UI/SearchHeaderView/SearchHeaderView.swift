//
//  SearchHeaderView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-05-21.
//

import UIKit

protocol SearchHeaderViewDelegate: AnyObject {
    func willOpenPicker (textFl: UITextField)
    func didSelectLocation (_ locationStr: String, _ btnTag: Int)
    func didSelectCustomLocation(_ btn:UIButton, location: Location)
    func didSelectSearch()
    func hideEditView()
}

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
    @IBOutlet weak var mSearchBtn: UIButton!
    
    @IBOutlet weak var mSearchBckgV: UIView!
    @IBOutlet weak var mSearchRightImgV: UIImageView!
    @IBOutlet weak var mSearchLeading: NSLayoutConstraint!
    
   
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
    var location:Location?

    let searchHeaderViewModel: SearchHeaderViewModel = SearchHeaderViewModel()
    weak var delegate: SearchHeaderViewDelegate?

    
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
        mPickUpDataTxtFl.text = Constant.Texts.pickUpDate
        mDayReturnDateBtn.isHidden = true
        mMonthReturnDateBtn.isHidden = true
        mReturnDateTxtFl.text =  Constant.Texts.returnDate
        mReturnTimeTxtFl.textColor = UIColor(named: "choose_date")
        mPickUpTimeTxtFl.textColor = UIColor(named: "choose_date")
        mPickUpLocationBtn.tintColor = UIColor(named: "choose_date")
        mReturnLocationBtn.tintColor = UIColor(named: "choose_date")

        mSearchBckgV.layer.cornerRadius = 8
        mSearchBtn.layer.cornerRadius = 8
        // border
        mLocationDropDownView.clipsToBounds = true
        mLocationDropDownView.layer.borderWidth = 0.3
        mLocationDropDownView.layer.borderColor = UIColor(named: "gradient_end")?.cgColor
        
        didSelectLocationFromList()
        didHideLocationList()
    }
    
    func setBorder() {
        // textField border
        setTextFieldBorder(leftTextField: mPickUpDataTxtFl, rightTextField: mReturnDateTxtFl, color: color_navigationBar!)
        setTextFieldBorder(leftTextField: mPickUpTimeTxtFl, rightTextField: mReturnTimeTxtFl, color: color_navigationBar!)
        //botton border
        mPickUpLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mSearchBtn.addBorder(color:color_navigationBar!, width: 1.0)
    }
    
    func setTextFieldBorder(leftTextField: UITextField, rightTextField: UITextField, color: UIColor) {
        leftTextField.addBorder(side: .bottom, color: color, width: 1.0)
        leftTextField.addBorder(side: .left, color: color, width: 1.0)
        leftTextField.addBorder(side: .top, color: color, width: 1.0)
        rightTextField.addBorder(side: .bottom, color: color, width: 1.0)
        rightTextField.addBorder(side: .right, color: color, width: 1.0)
        rightTextField.addBorder(side: .top, color: color, width: 1.0)
    }
    /// Set pick up location info
    func setPickUpLocationInfo(searchModel: SearchModel) {
        mPickUpLocationBtn.setTitleColor(color_entered_date!, for: .normal)
        mPickUpLocationBtn.titleLabel?.font = font_search_title
        mPickUpLocationBtn.setTitle(searchModel.pickUpLocation, for: .normal)
        if searchModel.isPickUpCustomLocation {
            mCheckBoxPickUpCustomLocBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
    }
    
    /// Set return location info
    func setReturnLocationInfo(searchModel: SearchModel) {
        mReturnLocationBtn.setTitleColor(color_entered_date!, for: .normal)
        mReturnLocationBtn.titleLabel?.font = font_search_title
        mReturnLocationBtn.setTitle(searchModel.returnLocation, for: .normal)
        if searchModel.isRetuCustomLocation {
            mCheckBoxReturnCustomLocBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
    }
    ///update Location Fields
    func updateLocationFields(place: String) {
       var searchModel = SearchModel()
        switch location {
        case .pickUpLocation: break
        case .returnLocation: break
        case .pickUpCustomLocation:
            searchModel.pickUpLocation = place
            searchModel.isPickUpCustomLocation = true
            setPickUpLocationInfo(searchModel: searchModel)
            break
        case .returnCustomLocation:
            searchModel.returnLocation = place
            searchModel.isRetuCustomLocation = true
            setReturnLocationInfo(searchModel: searchModel)
            break
        default:
            break
        }
    }
    
    func showLocationList() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.setShadow(color: UIColor(named: "gradient_end")!)
            self.mLocationDropDownView.mheightLayoutConst.constant = 172.0
            self.layoutIfNeeded()
        })
    }
    
    func hiddenLocationList() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.mheightLayoutConst.constant = 0.0
            self.mLocationLb.textColor = color_search_placeholder
            self.layoutIfNeeded()
        })
    }
    
    private func didSelectLocationFromList () {
        mLocationDropDownView.didSelectLocation = { [weak self] txt in
            self?.delegate?.didSelectLocation(txt, (self?.currLocationBtn.tag)!)
            self?.currLocationBtn.setTitle(txt, for: .normal)
            self?.currLocationBtn.titleLabel!.font = font_selected_filter
            self?.currLocationBtn.setTitleColor(color_entered_date, for: .normal)
            self!.currLocationDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            
            if self?.currLocationBtn.tag == 4 { //pick up location
                self?.location = .pickUpLocation
                UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_pickUpLocation)
                self?.mCheckBoxPickUpCustomLocBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)

            } else { // return location
                self?.location = .returnLocation
                UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_returnLocation)
                self?.mCheckBoxReturnCustomLocBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
            }

            if self?.mErrorMessageLb.isHidden == false{
                
              let _ = self?.checkFieldsFilled()
            }
            self?.pickUPDropisClose = true
            self?.returnDropisClose = true
        }
    }
   
    private func didHideLocationList () {
        mLocationDropDownView.hiddenLocationList = { [weak self] in
            self?.hiddenLocationList()
            self?.mLocationDropDownView.layer.shadowOpacity = 0;

        }
    }
   
    private func searchClicked(){
        if checkFieldsFilled() {
            UIView.animate(withDuration: 0.5) { [self] in
                self.mSearchLeading.constant = self.mSearchBckgV.bounds.width - self.mSearchBtn.frame.size.width
                self.mSearchBckgV.layoutIfNeeded()

            } completion: { [self] _ in
                self.delegate?.didSelectSearch()

            }

        }
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

      @IBAction func search(_ sender: UIButton) {
        searchClicked()
      }
    
    @IBAction func searchLeftSwipe(_ sender: UISwipeGestureRecognizer) {
        searchClicked()
    }

    @IBAction func pickUpLocation(_ sender: UIButton) {
        mLocationDropDownView.mPickUpLocationTableView.reloadData()
        currLocationBtn = sender
        currLocationDropImgV = mPickUpTimeDropImgV
        
        if !returnDropisClose {
            mReturnDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            returnDropisClose = true
        }

        if pickUPDropisClose {
            mPickUpTimeDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
            showLocationList()
        } else {
            mPickUpTimeDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            hiddenLocationList()
        }
        pickUPDropisClose = !pickUPDropisClose
    }
    
    @IBAction func returnLocation(_ sender: UIButton) {
       mLocationDropDownView.mPickUpLocationTableView.reloadData()
        currLocationBtn = sender
        currLocationDropImgV = mReturnDropImgV
        
        if !pickUPDropisClose {
            mPickUpTimeDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            pickUPDropisClose = true
        }
       
        if returnDropisClose {
            mReturnDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
            showLocationList()
        } else {
            mReturnDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            hiddenLocationList()
        }
        returnDropisClose = !returnDropisClose
    }
    
//MARK: ACTIONS
//MARK: ------------------

    @IBAction func checkBoxPickUpCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
            mPickUpLocationBtn.setTitle(Constant.Texts.pickUpLocation, for: .normal)
            mPickUpLocationBtn.setTitleColor(color_choose_date!, for: .normal)
            mPickUpLocationBtn.titleLabel?.font = font_placeholder
        } else {
           // sender.setImage(img_check_box, for: .normal)
            location = .pickUpCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxPickUpCustomLocBtn,
                                              location: location!)

        }
    }
    @IBAction func pickUpCustomLocation(_ sender: UIButton) {
       
        
    }
    @IBAction func checkBoxReturnCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box {
            mReturnLocationBtn.setTitle(Constant.Texts.returnLocation, for: .normal)
            mReturnLocationBtn.setTitleColor(color_choose_date!, for: .normal)
            mReturnLocationBtn.titleLabel?.font = font_placeholder
            sender.setImage(img_uncheck_box, for: .normal)
        } else {
           // sender.setImage(img_check_box, for: .normal)
            location = .returnCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxReturnCustomLocBtn,
                                              location: location!)
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
        delegate?.hideEditView()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.willOpenPicker(textFl: textField)
    }

}
