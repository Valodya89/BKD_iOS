//
//  CarouselView.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-05-21.
//

import UIKit
import iCarousel

enum Categorys: Int {
    case trucs = 0
    case frigoVans
    case vans
    case doubleCabs
    case boxTrucs
    var index: Int {
           return rawValue
       }


}

class CarouselView: UIView,  iCarouselDataSource, iCarouselDelegate {
    var carouselCellV: CarouselCellView?
    var didChangeCategory: ((Int) -> Void)?

    let categoryCarousel:iCarousel =  {
        let view = iCarousel()
        view.type = .coverFlow
       // view.bounceDistance = 10
        view.backgroundColor = .clear

        return view
    }()


    override func awakeFromNib() {
           superview?.awakeFromNib()
        self.addSubview(categoryCarousel)

        categoryCarousel.delegate = self
        categoryCarousel.dataSource = self
        categoryCarousel.frame = self.bounds
        categoryCarousel.currentItemIndex = CategoryCarouselData.categoryCarouselModel.count/2

       }
    func carouselCellView() -> CarouselCellView {
       let carouselCell = CarouselCellView()
       let carouselCellVHeight = self.frame.height *  1.00452
        let carouselCellVWidth = self.frame.width * 0.269333
        carouselCell.frame = CGRect(x: 0, y: 0, width: carouselCellVWidth, height: carouselCellVHeight)
        return carouselCell
    }
    //MARK iCarouselDataSource
    //MARK: -----------------------

    func numberOfItems(in carousel: iCarousel) -> Int {
        return CategoryCarouselData.categoryCarouselModel.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let carouselModel = CategoryCarouselData.categoryCarouselModel[index]
        let view: CarouselCellView = carouselCellView()


        view.mCategoryLb.text = carouselModel.categoryName
        view.mCategoryImg.image = carouselModel.CategoryImg
        view.mCategoryImg.setTintColor(color: color_carousel_img_tint!)
        view.mCategoryLb.textColor = .white

        view.backgroundColor = color_carousel
        if (index == carousel.currentItemIndex) {
            view.mCategoryImg.setTintColor(color: color_selected_filter_fields!)
            view.mCategoryLb.textColor = color_selected_filter_fields
            view.backgroundColor = color_menu
            view.mImgHeight.constant += 15
            view.mimgWidth.constant += 15
            view.mCategoryImg.layoutIfNeeded()
        }
        return view
    }


    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 0.7//0.5
            default: return value
        }
    }


    //MARK: iCarouselDelegate
    //MARK: -----------------------
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        didChangeCategory?(carousel.currentItemIndex)
        carousel.reloadData()
    }

}

