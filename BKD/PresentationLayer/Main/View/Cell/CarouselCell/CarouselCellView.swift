//
//  CarouselCellView.swift
//  BKD
//
//  Created by Karine Karapetyan on 28-05-21.
//

import UIKit

class CarouselCellView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mCategoryLb: UILabel!
    @IBOutlet weak var mCategoryImg: UIImageView!
    @IBOutlet weak var mImgHeight: NSLayoutConstraint!
    @IBOutlet weak var mimgWidth: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(Constant.NibNames.Carousel, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setUpView()
    }
    func setUpView() {
        self.setShadow(color: .lightGray)
        self.layer.cornerRadius = 2.0
        
    }
}
