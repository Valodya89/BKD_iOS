//
//  SearchHeaderView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-05-21.
//

import UIKit

enum DatePicker {
    case pickUpDate
    case returnDate
    case pickUpTime
    case returnTime
    case none
}

protocol SearchHeaderViewDelegate: AnyObject {
    func willOpenPicker (textFl: UITextField, pickerState: DatePicker)
    func didSelectLocation (_ parking: Parking, _ btnTag: Int)
    func didSelectCustomLocation(_ btn:UIButton)
    func didDeselectCustomLocation(tag: Int)
    func didSelectSearch()
    func hideEditView()
}

class SearchHeaderView: UIView, UITextFieldDelegate {

    static let identifier = "SearchHeaderView"
    
    @IBOutlet weak var mPickUpDataTxtFl: TextField!
    @IBOutlet weak var mReturnDateTxtFl: TextField!
   
    @IBOutlet weak var mCheckBoxPickUpCustomLocBtn: UIButton!
    @IBOutlet weak var mCheckBoxReturnCustomLocBtn: UIButton!
    @IBOutlet weak var mReturnCustomLocationBtn: UIButton!
    @IBOutlet weak var mPickUpCustomLocationBtn: UIButton!
    
    @IBOutlet weak var mCarouselV: UIView!
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
    
    
    //MARK: Variables
   // var pickerList:[String] = []
    var pickUPDropisClose: Bool = true
    var returnDropisClose: Bool = true
    var currLocationBtn = UIButton()
    var currLocationDropImgV = UIImageView()
    var locationPickUp:LocationPickUp?
    var locationReturn:LocationReturn?
    var datePicker: DatePicker = .none

    let searchHeaderViewModel: SearchHeaderViewModel = SearchHeaderViewModel()

    weak var delegate: SearchHeaderViewDelegate?

    var pickUpDate: Date? {
        didSet {
            if !(pickUpDate?.isSameDates(date: oldValue))! {
                enableSearch()
            }
        }
    }
    var returnDate: Date? {
        didSet {
            if !(returnDate?.isSameDates(date: oldValue))! {
                enableSearch()
            }
        }
    }
    var pickUpTime: Date? {
        didSet {
            if pickUpTime?.time != oldValue?.time {
                enableSearch()
            }
        }
    }
    var returnTime: Date? {
        didSet {
            if  returnTime?.time != oldValue?.time {
                enableSearch()
            }
        }
    }
    var categore:Int = 0{
        didSet {
            if categore != oldValue {
                enableSearch()
            }
        }
    }
    
    var pickUpLocation: String? {
        didSet {
            if pickUpLocation != oldValue &&
                oldValue != nil {
                enableSearch()
            }
        }
    }
    
    var returnLocation: String? {
        didSet {
            if returnLocation != oldValue &&
                oldValue != nil {
                enableSearch()
            }
        }
    }
    func enableSearch() {
        mSearchBckgV.isUserInteractionEnabled = true
        mSearchBckgV.alpha = 1.0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mPickUpLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mSearchBtn.addBorder(color:color_navigationBar!, width: 1.0)
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
        
        mPickUpTimeTxtFl.setPlaceholder(string: Constant.Texts.selectTime, font: font_placeholder!, color: color_choose_date!)
        mReturnTimeTxtFl.setPlaceholder(string: Constant.Texts.selectTime, font: font_placeholder!, color: color_choose_date!)
       
        mPickUpDataTxtFl.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        mDayPickUpBtn.isHidden = true
        mMonthPickUpBtn.isHidden = true
        mPickUpDataTxtFl.text = Constant.Texts.pickUpDate
        mDayReturnDateBtn.isHidden = true
        mMonthReturnDateBtn.isHidden = true
        mReturnDateTxtFl.text =  Constant.Texts.returnDate
        mPickUpLocationBtn.tintColor = color_choose_date
        mReturnLocationBtn.tintColor = color_choose_date

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
    
    /// Set textField border
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

    //Update pick up data field
    func updatePickUpDate(datePicker: UIDatePicker) {
        mDayPickUpBtn.isHidden = false
        mMonthPickUpBtn.isHidden = false
        //mPickUpDataTxtFl.text = ""
        mPickUpDataTxtFl.textColor = .clear
        mDayPickUpBtn.setTitle(datePicker.date.getDay(), for: .normal)

        mMonthPickUpBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
        mDateLb.textColor = color_search_placeholder
    }
    
    
    //Update pick up data field
    func updateReturnDate(datePicker: UIDatePicker) {
        mDayReturnDateBtn.isHidden = false
        mMonthReturnDateBtn.isHidden = false
       // mReturnDateTxtFl.text = ""
        mReturnDateTxtFl.textColor = .clear
        mDayReturnDateBtn.setTitle(datePicker.date.getDay(), for: .normal)

        mMonthReturnDateBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
        mDateLb.textColor = color_search_placeholder
    }
    
    //Update time field
    func updateTime(responderTxtFl: UITextField, text: String) {
        DispatchQueue.main.async {
            responderTxtFl.text = text
            responderTxtFl.textColor = color_entered_date
            responderTxtFl.font = font_search_title
            self.mTimeLb.textColor = color_search_placeholder
        }
       

    }
    
//    //Will put new values from pickerDate
//    func showSelectedDate(dayBtn : UIButton?,
//                          monthBtn: UIButton?) {
//        if datePicker == .pickUpTime ||  datePicker == .returnTime{
//
//
//            responderTxtFl.text = pickerList![ pickerV.selectedRow(inComponent: 0)]
//            responderTxtFl.textColor = color_entered_date
//            mTimeLb.textColor = color_search_placeholder
//
//        } else {
//            dayBtn?.setTitle(datePicker.date.getDay(), for: .normal)
//            monthBtn?.setTitle(datePicker.date.getMonthAndWeek(lng: "en"), for: .normal)
//            mDateLb.textColor = color_search_placeholder
//        }
//    }
    
    ///update Location Fields
    func updateCustomLocationFields(place: String, didResult: @escaping (Bool) -> ()) {
        
       var searchModel = SearchModel()
       var isPickUpLocation = true

        if locationPickUp == LocationPickUp.pickUpCustomLocation {
            searchModel.pickUpLocation = place
            searchModel.isPickUpCustomLocation = true
            setPickUpLocationInfo(searchModel: searchModel)
        } else if locationReturn == LocationReturn.returnCustomLocation {
            searchModel.returnLocation = place
            searchModel.isRetuCustomLocation = true
            setReturnLocationInfo(searchModel: searchModel)
            isPickUpLocation = false
        }
        didResult(isPickUpLocation)
    }
    
    
    func configureTimeTextField(txtFl: UITextField) {
            txtFl.font =  UIFont.init(name: (txtFl.font?.fontName)!, size: 10.0)
            txtFl.textColor = color_choose_date
            if txtFl.tag == 2 { //Pick up Timer
                pickUpTime = nil
                txtFl.text = Constant.Texts.pickUpTime
                pickUpTime = nil
            } else { // return timer
                returnTime = nil
                txtFl.text = Constant.Texts.returnTime
                returnTime = nil
            }
            if mPickUpTimeTxtFl.text!.count <= 0 && mReturnTimeTxtFl.text!.count <= 0{
                mTimeLb.textColor = .clear
            }
    
        }
    
    func resetReturnTime() {
        mReturnTimeTxtFl.text = Constant.Texts.returnTime
        mReturnTimeTxtFl.font = font_placeholder
        mReturnTimeTxtFl.textColor = color_choose_date
        returnTime = nil
    }

    
    func showLocationList() {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.setShadow(color: UIColor(named: "gradient_end")!)
            self.mLocationDropDownView.mheightLayoutConst.constant = self.mLocationDropDownView.parkingList.count >=
                3 ? locationList_height : CGFloat(self.mLocationDropDownView.parkingList.count) * locationList_cell_height
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
        mLocationDropDownView.didSelectLocation = { [weak self] parking in
            self?.delegate?.didSelectLocation(parking, (self?.currLocationBtn.tag)!)
            self?.currLocationBtn.setTitle(parking.name, for: .normal)
            self?.currLocationBtn.titleLabel!.font = font_selected_filter
            self?.currLocationBtn.setTitleColor(color_entered_date, for: .normal)
            self!.currLocationDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            
            if self?.currLocationBtn.tag == 4 { //pick up location
                self?.locationPickUp = .pickUpLocation
                self?.pickUpLocation = self?.currLocationBtn.title(for: .normal)
                self?.mCheckBoxPickUpCustomLocBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)

            } else { // return location
                self?.locationReturn = .returnLocation
                self?.returnLocation = self?.currLocationBtn.title(for: .normal)
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
    
//MARK: - Validations
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
    
   
    //MARK: - Actions
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
    

    @IBAction func checkBoxPickUpCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
            mPickUpLocationBtn.setTitle(Constant.Texts.pickUpLocation, for: .normal)
            mPickUpLocationBtn.setTitleColor(color_choose_date!, for: .normal)
            mPickUpLocationBtn.titleLabel?.font = font_placeholder
            locationPickUp = .none
            delegate?.didDeselectCustomLocation(tag: sender.tag)

        } else {
           // sender.setImage(img_check_box, for: .normal)
            locationPickUp = .pickUpCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxPickUpCustomLocBtn)

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
            locationReturn = .none
            delegate?.didDeselectCustomLocation(tag: sender.tag)
        } else {
           // sender.setImage(img_check_box, for: .normal)
            locationPickUp = .none
            locationReturn = .returnCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxReturnCustomLocBtn)
        }
    }
    
    @IBAction func pickUp(_ sender: Any) {
        datePicker = .pickUpDate
        mPickUpDataTxtFl.becomeFirstResponder()
    }
    
    @IBAction func returnDate(_ sender: Any) {
        datePicker = .returnDate
        mReturnDateTxtFl.becomeFirstResponder()
    }
    @IBAction func pickUpTime(_ sender: Any) {
        datePicker = .pickUpTime
        mPickUpTimeTxtFl.becomeFirstResponder()
    }
    @IBAction func returnTime(_ sender: Any) {
        datePicker = .returnTime
        mReturnTimeTxtFl.becomeFirstResponder()
    }
    
    @IBAction func arrow(_ sender: UIButton) {
        delegate?.hideEditView()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {

        delegate?.willOpenPicker(textFl: textField, pickerState: datePicker)
    
    }

}
