//
//  PersonalInfoTableCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-12-21.
//

import UIKit

class PersonalInfoTableCell: UITableViewCell {
    static let identifier = "PersonalInfoTableCell"
    static func nib() -> UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
    
    @IBOutlet weak var mVerifyBtn: UIButton!
    @IBOutlet weak var mVerifiedV: UIView!
    @IBOutlet weak var mTxtFl: TextField!
    @IBOutlet weak var mFieldNameLb: UILabel!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    ///Set cell information
    func setCellInfo(item: MainDriverModel, index: Int, isEdit: Bool) {
        mFieldNameLb.text = item.fieldName
        if item.fieldName == Constant.Texts.phoneNumber {
            //If verified
            mVerifiedV.isHidden = false
        }
        
        //set date filed
        if item.isDate {
            let dateString = item.fieldValue!.components(separatedBy: "T")
            let date = dateString[0].stringToDateWithoutTime()
            
            mTxtFl.text = date!.getDay() + " " + date!.getMonth(lng: "en") + " " + date!.getYear()
        } else {
            //set country filed
            if item.fieldName == Constant.Texts.country {
                let country = ApplicationSettings.shared.countryList?.filter { $0.id == item.fieldValue }
                mTxtFl.text =  country?.first?.country
            } else {
                mTxtFl.text = item.fieldValue
            }
        }
    }
    
}
