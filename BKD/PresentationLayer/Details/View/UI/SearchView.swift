//
//  SearchView.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-06-21.
//

import UIKit

enum LocationPickUp {
    case pickUpLocation
    case pickUpCustomLocation
}
enum LocationReturn {
    case returnLocation
    case returnCustomLocation
}

protocol SearchViewDelegate: AnyObject {
    func willOpenPicker (textFl: UITextField)
    func didSelectLocation (_ text:String, _ tag:Int)
    func didSelectCustomLocation(_ btn:UIButton)
    func didDeselectCustomLocation(tag: Int)
}

class SearchView: UIView, UITextFieldDelegate {
//MARK: Outlets
    //Date
    @IBOutlet weak var mPickUpDataTxtFl: TextField!
    @IBOutlet weak var mReturnDateTxtFl: TextField!
    @IBOutlet weak var mDayPickUpBtn: UIButton!
    @IBOutlet weak var mMonthPickUpBtn: UIButton!
    @IBOutlet weak var mDayReturnDateBtn: UIButton!
    @IBOutlet weak var mMonthReturnDateBtn: UIButton!
    @IBOutlet weak var mPickUpDateImgV: UIImageView!
    @IBOutlet weak var mReturnDateImgV: UIImageView!
   
//Time
    @IBOutlet weak var mPickUpTimeTxtFl: TextField!
    @IBOutlet weak var mReturnTimeTxtFl: TextField!
    @IBOutlet weak var mPickUpTimeBtn: UIButton!
    @IBOutlet weak var mReturnTimeBtn: UIButton!
    @IBOutlet weak var mReturnTimeImgV: UIImageView!
    @IBOutlet weak var mPickUpTimeImgV: UIImageView!
    
    
  //Location
    @IBOutlet weak var mPickUpLocationBtn: UIButton!
    @IBOutlet weak var mReturnLocationBtn: UIButton!
    @IBOutlet weak var mPickUpTimeDropImgV: UIImageView!
    @IBOutlet weak var mReturnDropImgV: UIImageView!
    
    //Custom location
    @IBOutlet weak var mCheckBoxPickUpCustomLocBtn: UIButton!
    @IBOutlet weak var mCheckBoxReturnCustomLocBtn: UIButton!
    @IBOutlet weak var mReturnCustomLocationBtn: UIButton!
    @IBOutlet weak var mPickUpCustomLocationBtn: UIButton!
    @IBOutlet weak var mLocationDropDownView: LocationDropDownView!

    //MARK:Variables

    var pickUPDropisClose: Bool = true
    var returnDropisClose: Bool = true
    var currLocationBtn = UIButton()
    var currLocationDropImgV = UIImageView()
    var responderTxtFl = UITextField()
    var locationPickUp:LocationPickUp?
    var locationReturn:LocationReturn?

    public var searchModel: SearchModel =  SearchModel()
    let detailsViewModel:DetailsViewModel = DetailsViewModel()

    weak var delegate: SearchViewDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        configureDelegate()
    }
    
    func setUpView() {
        setBorder()

        mPickUpDataTxtFl.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        mDayPickUpBtn.isHidden = true
        mMonthPickUpBtn.isHidden = true
        mPickUpDataTxtFl.text = Constant.Texts.pickUpDate
        mDayReturnDateBtn.isHidden = true
        mMonthReturnDateBtn.isHidden = true
        mReturnDateTxtFl.text =  Constant.Texts.returnDate
        mReturnTimeTxtFl.textColor = color_choose_date!
        mPickUpTimeTxtFl.textColor = color_choose_date!
        mPickUpLocationBtn.tintColor = color_choose_date!
        mReturnLocationBtn.tintColor = color_choose_date!
        
        // border
        mLocationDropDownView.clipsToBounds = true
        mLocationDropDownView.layer.borderWidth = 0.3
        mLocationDropDownView.layer.borderColor = color_gradient_end?.cgColor
        
        // set padding
        mPickUpLocationBtn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                                          bottom: 0.0, right: 25.0)
        mReturnLocationBtn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                                          bottom: 0.0,right: 25.0)


        didSelectLocationFromList()
        didHideLocationList()
    }
    
    func setBorder() {
        mPickUpDataTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mPickUpTimeTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mPickUpLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
    }
    
    /// Set pick up date info
    func setPickUpDateInfo(searchModel: SearchModel)  {
        showDateInfoViews(dayBtn: mDayPickUpBtn,
                          monthBtn:
                            mMonthPickUpBtn,
                          txtFl: mPickUpDataTxtFl)
        mDayPickUpBtn.setTitle(String((searchModel.pickUpDate!.get(.day))), for: .normal)
        mMonthPickUpBtn.setTitle(searchModel.pickUpDate!.getMonthAndWeek(lng: "en"), for: .normal)
    }
    
    /// Set return date info
    func setReturnDateInfo(searchModel: SearchModel) {
        showDateInfoViews(dayBtn: mDayReturnDateBtn,
                          monthBtn:
                            mMonthReturnDateBtn,
                          txtFl: mReturnDateTxtFl)
        mDayReturnDateBtn.setTitle(String(searchModel.returnDate!.get(.day)), for: .normal)
        mMonthReturnDateBtn.setTitle(searchModel.returnDate!.getMonthAndWeek(lng: "en"), for: .normal)
    }
    
    /// Set pick up timr info
    func setPickUpTimeInfo(searchModel: SearchModel) {
        mPickUpTimeTxtFl.font =  UIFont.init(name: (mPickUpTimeTxtFl.font?.fontName)!, size: 18.0)
        mPickUpTimeTxtFl.textColor = color_entered_date
        mPickUpTimeTxtFl.text = searchModel.pickUpTime!.getHour()
    }
    
    /// Set return time info
    func setReturnTimeInfo(searchModel: SearchModel, tariff: Tariff) {
        mReturnTimeTxtFl.font =  UIFont.init(name: (mReturnTimeTxtFl.font?.fontName)!, size: 18.0)
        mReturnTimeTxtFl.textColor = (tariff == .flexible) ? color_entered_date : color_search_passive
       mReturnTimeTxtFl.text = searchModel.returnTime!.getHour()
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
    
    ///configure search passive fields
    func configureSearchPassiveFields(tariff: Tariff) {
        var isPassive = true
        if tariff != .flexible {
            isPassive = false
            mReturnTimeTxtFl.addBorder(color: color_search_passive!, width: 1.0)
            mReturnDateTxtFl.addBorder(color: color_search_passive!, width: 1.0)
            
            mDayReturnDateBtn.setTitleColor(color_search_passive!, for: .normal)
            mMonthReturnDateBtn.setTitleColor(color_search_passive!, for: .normal)
            mReturnTimeTxtFl.textColor = color_search_passive!
            mReturnDateTxtFl.textColor = (mReturnTimeTxtFl.text == Constant.Texts.returnDate) ? color_choose_date : color_search_passive!
            
            mReturnDateImgV.setTintColor(color:  color_search_passive!)
            mReturnTimeImgV.setTintColor(color:  color_search_passive!)
        } else {
            mReturnTimeTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
            mReturnDateTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
            
            mDayReturnDateBtn.setTitleColor(color_entered_date!, for: .normal)
            mMonthReturnDateBtn.setTitleColor(color_entered_date!, for: .normal)
            
            mReturnDateImgV.setTintColor(color:  color_navigationBar!)
            mReturnTimeImgV.setTintColor(color:  color_navigationBar!)
            mReturnTimeTxtFl.textColor = (mReturnTimeTxtFl.text == Constant.Texts.returnTime) ? color_choose_date! : color_entered_date!
        }
        mReturnDateTxtFl.isUserInteractionEnabled = isPassive
        mReturnTimeTxtFl.isUserInteractionEnabled = isPassive
    }
    
    func configureDelegate() {
        mPickUpDataTxtFl.delegate = self
        mReturnDateTxtFl.delegate = self
        mPickUpTimeTxtFl.delegate = self
        mReturnTimeTxtFl.delegate = self
    }
    
    private func didSelectLocationFromList () {
        mLocationDropDownView.didSelectLocation = { [weak self] txt in
            self?.delegate?.didSelectLocation(txt, (self?.currLocationBtn.tag)!)
            
            self?.currLocationBtn.setTitle(txt, for: .normal)
            self?.currLocationBtn.titleLabel!.font = font_selected_filter
            self?.currLocationBtn.setTitleColor(color_entered_date, for: .normal)
            self!.currLocationDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            
            if self?.currLocationBtn.tag == 4 { //pick up location
                self?.locationPickUp = .pickUpLocation
                UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_pickUpLocation)
                self?.mCheckBoxPickUpCustomLocBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
                
            } else { // return location
                self?.locationReturn = .returnLocation
                UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_returnLocation)
                self?.mCheckBoxReturnCustomLocBtn.setImage(#imageLiteral(resourceName: "uncheck_box"), for: .normal)
            }

            self?.pickUPDropisClose = true
            self?.returnDropisClose = true
        }
    }

    private func animateLocationList(isShow: Bool) {
        UIView.animate(withDuration: 0.3, animations: { [self] in
            self.mLocationDropDownView.setShadow(color: color_gradient_end!)
           let height = isShow ? 172.0 : 0.0
            self.mLocationDropDownView.mheightLayoutConst.constant = CGFloat(height)
            self.mLocationDropDownView.layoutIfNeeded()
        })
    }
    
    private func didHideLocationList () {
        mLocationDropDownView.hiddenLocationList = { [weak self] in
            self?.animateLocationList(isShow: false)
            self?.mLocationDropDownView.layer.shadowOpacity = 0;

        }
    }
    
    ///Will delete placeholder views and show search date views
    func showDateInfoViews(dayBtn : UIButton,
                           monthBtn: UIButton,
                           txtFl: UITextField)  {
        dayBtn.isHidden = false
        monthBtn.isHidden = false
        txtFl.text = ""
    }
    
    ///Update search fields
    func updateSearchFields(searchModel:SearchModel, tariff: Tariff){
        setPickUpDateInfo(searchModel: searchModel)
        setReturnDateInfo(searchModel: searchModel)
        setPickUpTimeInfo(searchModel: searchModel)
        setReturnTimeInfo(searchModel: searchModel, tariff: tariff)
        setPickUpLocationInfo(searchModel: searchModel)
        setReturnLocationInfo(searchModel: searchModel)
    }
    
    /// will update time fields depend on tariff option
    func updateSearchTimes(searchModel:SearchModel, tariff:Tariff) {
        setReturnTimeInfo(searchModel: searchModel, tariff: tariff)
            
            if let _ = searchModel.returnDate {
                showDateInfoViews(dayBtn: mDayReturnDateBtn,
                                  monthBtn:
                                    mMonthReturnDateBtn,
                                  txtFl: mReturnDateTxtFl)
                mDayReturnDateBtn.setTitle(String(searchModel.returnTime!.get(.day)), for: .normal)
                mMonthReturnDateBtn.setTitle(searchModel.returnTime!.getMonthAndWeek(lng: "en"), for: .normal)
            }
    }
    
    
    /// will update date fields depend on tariff option
    func updateSearchDate(searchModel:SearchModel) {
        setReturnDateInfo(searchModel: searchModel)
        if let _ = searchModel.pickUpTime {
            mReturnTimeTxtFl.text = searchModel.returnDate!.getHour()
        }
    }
    
    ///Update search filled fields
    func updateSearchFilledFields(tariff:Tariff,
                                  searchModel:SearchModel){
        
        if tariff == .hourly &&  searchModel.pickUpTime != nil {
            updateSearchTimes(searchModel: searchModel, tariff:tariff)
        } else if searchModel.pickUpDate != nil {
            updateSearchDate(searchModel: searchModel)
        }
    }
    
    ///update Location Fields
    func updateCustomLocationFields(place: String, didResult: @escaping (Bool) -> ()) {
        
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
    
//MARK: ACTIONS
    //MARK: ---------------
    @IBAction func pickupDate(_ sender: UIButton) {
        mPickUpDataTxtFl.becomeFirstResponder()
    }
    
    @IBAction func returnDate(_ sender: UIButton) {
        mReturnDateTxtFl.becomeFirstResponder()
    }
    
    @IBAction func pickupTime(_ sender: UIButton) {
        mPickUpTimeTxtFl.becomeFirstResponder()
    }
    
    @IBAction func returnTime(_ sender: UIButton) {
        mReturnTimeTxtFl.becomeFirstResponder()

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
            animateLocationList(isShow: true)
        } else {
            mPickUpTimeDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            animateLocationList(isShow: false)
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
            animateLocationList(isShow: true)
         } else {
             mReturnDropImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
            animateLocationList(isShow: false)
         }
         returnDropisClose = !returnDropisClose
    }
    
    @IBAction func checkBoxPickupCustomLocation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
  
            mPickUpLocationBtn.setTitle(Constant.Texts.pickUpLocation, for: .normal)
            mPickUpLocationBtn.setTitleColor(color_choose_date!, for: .normal)
            mPickUpLocationBtn.titleLabel?.font = font_placeholder
            locationPickUp = .none
            delegate?.didDeselectCustomLocation(tag: sender.tag)
        } else {
            locationPickUp = .pickUpCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxPickUpCustomLocBtn)

        }
    }
    
    @IBAction func checkBoxReturnCustomLOcation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box {

            mReturnLocationBtn.setTitle(Constant.Texts.returnLocation, for: .normal)
            mReturnLocationBtn.setTitleColor(color_choose_date!, for: .normal)
            mReturnLocationBtn.titleLabel?.font = font_placeholder
            sender.setImage(img_uncheck_box, for: .normal)
            locationReturn = .none
            delegate?.didDeselectCustomLocation(tag: sender.tag)

        } else {
           // sender.setImage(img_check_box, for: .normal)
            locationReturn = .returnCustomLocation
            delegate?.didSelectCustomLocation(mCheckBoxReturnCustomLocBtn)
        }
    }
    
    @IBAction func pickupCustomLocation(_ sender: UIButton) {
    }
    
    @IBAction func returnCustomLocation(_ sender: UIButton) {
    }
    
  //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
       responderTxtFl = textField
        delegate?.willOpenPicker(textFl: textField)
        
    }
}
