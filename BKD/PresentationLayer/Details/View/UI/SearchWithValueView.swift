//
//  SearchWithValueView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit

protocol SearchWithValueViewDelegate: AnyObject {
    func didPressEdit()
}

class SearchWithValueView: UIStackView {
    
    //MARK: Outlet
    @IBOutlet weak var mPickupDateBtn: UIButton!
    @IBOutlet weak var mPickupDayBtn: UIButton!
    @IBOutlet weak var mReturnDateBtn: UIButton!
    @IBOutlet weak var mReturnDayBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mPickupLocationLb: UILabel!
    @IBOutlet weak var mReturnLocationLb: UILabel!
    
    //MARK: Variables
    weak var delegate: SearchWithValueViewDelegate?
    public var searchModel: SearchModel =  SearchModel()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupView()
    }
    
    func setupView() {
        self.setShadow(color: color_shadow!)
        if let _ = searchModel.pickUpDate{
            mPickupDayBtn.setTitle(String((searchModel.pickUpDate!.get(.day))), for: .normal)
            mPickupDateBtn.setTitle(searchModel.pickUpDate!.getMonthAndWeek(lng: "en"), for: .normal)
        }
        
        if let _ = searchModel.returnDate{
            mReturnDayBtn.setTitle(String(searchModel.returnDate!.get(.day)), for: .normal)
            mReturnDateBtn.setTitle(searchModel.returnDate!.getMonthAndWeek(lng: "en"), for: .normal)
        }
        
        if let _ = searchModel.pickUpLocation, let _ = searchModel.returnLocation {
            mPickupLocationLb.text = searchModel.pickUpLocation!
            mReturnLocationLb.text = searchModel.returnLocation!
        }

    }
    
   //MARK: ACTION
    @IBAction func edit(_ sender: UIButton) {
        delegate?.didPressEdit()
    }
    

}
