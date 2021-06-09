//
//  SearchResultView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-05-21.
//

import UIKit

class SearchResultView: UIView {

    @IBOutlet weak var mSearchResultBckgV: UIView!
    
    @IBOutlet weak var mSearchResultStackV: UIStackView!
    @IBOutlet weak var mPickUpMonthBtn: UIButton!
    @IBOutlet weak var mPickUpDayBtn: UIButton!
    @IBOutlet weak var mPickUpLocationLb: UILabel!
    
    @IBOutlet weak var mReturnDayBtn: UIButton!
    @IBOutlet weak var mReturnLocationLb: UILabel!
    @IBOutlet weak var mReturnMonthBtn: UIButton!
    @IBOutlet weak var mEditBtn: UIButton!
    @IBOutlet weak var mFilterImgV: UIImageView!
    @IBOutlet weak var mFilterV: UIView!
    @IBOutlet weak var mFilterBtn: UIButton!
    @IBOutlet weak var mFilterBckgV: UIView!
    @IBOutlet weak var mNoticeLb: UILabel!
    @IBOutlet var contentView: UIView!
    
    var isPressedFilter: Bool = false
    
    var didPressFilter: ((Bool) -> Void)?
    var didPressEdit: (() -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(Constant.NibNames.SearchResult, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
    func setUpView() {
       // mSearchResultStackV.setShadowByBezierPath(color: UIColor.lightGray)
        mSearchResultStackV.setShadow(color: UIColor.lightGray)
    }
    
    //MARK: ACTIONS
    @IBAction func edit(_ sender: UIButton) {
        didPressEdit!()
    }
    @IBAction func filter(_ sender: UIButton) {
        if  !isPressedFilter {
            mFilterImgV.image = UIImage(named: "hide_car_param")
        } else {
            mFilterImgV.image = UIImage(named: "show_car_param")
        }
        isPressedFilter = !isPressedFilter
        didPressFilter!(isPressedFilter)

    }
    
}

