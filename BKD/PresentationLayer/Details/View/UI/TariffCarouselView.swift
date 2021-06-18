//
//  TariffCarouselView.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-06-21.
//

import UIKit
import iCarousel

protocol TariffCarouselViewDelegate: AnyObject {
    func didPressMore()
}
class TariffCarouselView: UIView,  iCarouselDataSource, iCarouselDelegate {
    var didChangeCategory: ((Int) -> Void)?

    var tariffCarouselCellV: TariffCarouselCell?
    weak var delegate: TariffCarouselViewDelegate?

    let tariffCarousel:iCarousel =  {
        let view = iCarousel()
        view.type = .invertedTimeMachine
        view.backgroundColor = .clear

        return view
    }()

    override func awakeFromNib() {
           superview?.awakeFromNib()
        self.addSubview(tariffCarousel)

        tariffCarousel.delegate = self
        tariffCarousel.dataSource = self
        tariffCarousel.frame = self.bounds
        tariffCarousel.currentItemIndex = 0

       }
    func carouselCellView() -> TariffCarouselCell {
       let carouselCell = TariffCarouselCell()
       let carouselCellVHeight = 230//self.frame.height *  0.284653
        let carouselCellVWidth = 195//self.frame.width * 0.471014
        carouselCell.frame = CGRect(x: 0, y: 0, width: carouselCellVWidth, height: carouselCellVHeight)
        return carouselCell
    }
    
    
    //MARK iCarouselDataSource
    //MARK: -----------------------
    func numberOfItems(in carousel: iCarousel) -> Int {
        return TariffSlideData.tariffSlideModel.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let carouselModel = TariffSlideData.tariffSlideModel[index]
        let view: TariffCarouselCell = carouselCellView()
        view.delegate = self
        if index != carousel.currentItemIndex {
            view.setUnselectedCellsInfo(item: carouselModel, index: index)
        } else {
            view.setSelectedCellInfo(item: carouselModel, index: index)
        }
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 0.15//0.5
            default: return value
        }
    }


    //MARK: iCarouselDelegate
    //MARK: -----------------------
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
     
//        didChangeCategory?(carousel.currentItemIndex)
        carousel.reloadData()
    }

}


//MARK: TariffCarouselCellDelegate
//MARK: ----------------------------
extension TariffCarouselView: TariffCarouselCellDelegate {
    func didPressMore() {
        delegate?.didPressMore()
    }
}
