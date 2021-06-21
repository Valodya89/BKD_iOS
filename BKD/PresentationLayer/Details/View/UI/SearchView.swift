//
//  SearchView.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-06-21.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didSelectPickUp (textFl: UITextField)
    func didSelectLocation (_ text:String, _ tag:Int)
    func didSelectCustomLocation(_ btn:UIButton, _ isShowAlert:Bool)
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
    weak var delegate: SearchViewDelegate?

   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        setBorder()
        configureDelegate()

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
        
        didSelectLocationFromList()
        didHideLocationList()
    }
    
    func setBorder() {
        mPickUpDataTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnDateTxtFl.addBorder(color: color_email!, width: 1.0)
        mPickUpTimeTxtFl.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnTimeTxtFl.addBorder(color: color_email!, width: 1.0)
        mPickUpLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
        mReturnLocationBtn.addBorder(color: color_navigationBar!, width: 1.0)
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
            self?.currLocationBtn.tag == 4 ?  UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_pickUpLocation) :  UserDefaults.standard.set(self?.currLocationBtn.title(for: .normal), forKey: key_returnLocation)

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
        } else {
            sender.setImage(img_check_box, for: .normal)
            let willShowLocationAlert: Bool = (mCheckBoxReturnCustomLocBtn.image(for: .normal) ==  img_check_box) ? false : true
                
            delegate?.didSelectCustomLocation(mCheckBoxPickUpCustomLocBtn, willShowLocationAlert)

        }
    }
    
    @IBAction func checkBoxReturnCustomLOcation(_ sender: UIButton) {
        if sender.image(for: .normal) ==  img_check_box { sender.setImage(img_uncheck_box, for: .normal)
        } else {
            sender.setImage(img_check_box, for: .normal)
            let willShowLocationAlert: Bool = (mCheckBoxPickUpCustomLocBtn.image(for: .normal) ==  img_check_box) ? false : true
                
            delegate?.didSelectCustomLocation(mCheckBoxReturnCustomLocBtn, willShowLocationAlert)
        }
    }
    
    @IBAction func pickupCustomLocation(_ sender: UIButton) {
    }
    
    @IBAction func returnCustomLocation(_ sender: UIButton) {
    }
    
  //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didSelectPickUp(textFl: textField)
        
    }
}
