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
    func didPressConfirm(tariff: Tariff, optionIndex: Int, optionstr: String)
    func willChangeTariffOption(tariff: Tariff, optionIndex: Int)
}
class TariffCarouselView: UIView,  iCarouselDataSource, iCarouselDelegate {
    var didChangeCategory: ((Int) -> Void)?

    var selectedSegmentIndex: Int?
    var tariffCarouselCellV: TariffCarouselCell?
    let tariffSlideViewModel = TariffSlideViewModel()
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
        setUpView()

       }
    func setUpView() {
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
            view.selectedSegmentIndex = selectedSegmentIndex ?? 0
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
    func willChangeOption(optionIndex: Int) {
        var optionIndex = optionIndex
        if Tariff.allCases[tariffCarousel.currentItemIndex] == .monthly {
            optionIndex = 0
        }
        delegate?.willChangeTariffOption(tariff: Tariff.allCases[tariffCarousel.currentItemIndex],
                                         optionIndex: optionIndex)
    }
    
    func showSearchView(optionIndex: Int) {
        let optionstr = tariffSlideViewModel.getOptionString(tariff:Tariff.allCases[tariffCarousel.currentItemIndex],
                                                             index: optionIndex)
        delegate?.didPressConfirm(tariff: Tariff.allCases[tariffCarousel.currentItemIndex],
                                  optionIndex: optionIndex,  optionstr: optionstr)

    }
    
    func didPressMore() {
        delegate?.didPressMore()
    }

}
