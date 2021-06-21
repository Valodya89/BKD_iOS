//
//  SearchWithValueView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit


class SearchWithValueView: UIStackView {
    
    //MARK: Outlet
    @IBOutlet weak var mPickupDateBtn: UIButton!
    @IBOutlet weak var mPickupDayBtn: UIButton!
    @IBOutlet weak var mReturnDateBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mPickupLocationLb: UILabel!
    @IBOutlet weak var mReturnLocationLb: UILabel!
  
    var didPressEdit: (() -> Void)?

  
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setShadow(color: color_shadow!)
    }
    
   //MARK: ACTION
    @IBAction func edit(_ sender: UIButton) {
        didPressEdit?()
    }
    

}
