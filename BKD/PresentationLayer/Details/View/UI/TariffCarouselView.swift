//
//  TariffCarouselView.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-06-21.
//

import UIKit
import iCarousel
import AVFoundation

protocol TariffCarouselViewDelegate: AnyObject {
    func didPressMore(tariffIndex: Int, optionIndex: Int)
    func didPressConfirm(tariff: TariffState,
                         optionIndex: Int,
                         optionstr: String,
                         options: [TariffSlideModel]?)
    func willChangeTariffOption(tariff: TariffState,
                                optionstr: String,
                                optionIndex: Int,
                                options: [TariffSlideModel]?)
}

class TariffCarouselView: UIView {
    
   public var tariffSlideList: [TariffSlideModel]?
   public var vehicleModel: VehicleModel?

    private var tariffCarouselCellV: TariffCarouselCell?
    private let tariffSlideViewModel = TariffSlideViewModel()
    weak var delegate: TariffCarouselViewDelegate?
    var selectedSegmentIndex: Int?
   // public var currentItemIndex: Int?
    
    let tariffCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .invertedTimeMachine
        view.backgroundColor = .clear
        return view
    }()
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        setUpView()
    }
    
    
    private func setUpView() {
        self.addSubview(tariffCarousel)
        tariffCarousel.delegate = self
        tariffCarousel.dataSource = self
        tariffCarousel.frame = self.bounds
        tariffCarousel.currentItemIndex = 0
    }
    
    private func carouselCellView() -> TariffCarouselCell {
        let carouselCell = TariffCarouselCell()
        let carouselCellVHeight = 230//self.frame.height *  0.284653
        let carouselCellVWidth = 195//self.frame.width * 0.471014
        carouselCell.frame = CGRect(x: 0, y: 0, width: carouselCellVWidth, height: carouselCellVHeight)
        return carouselCell
    }
    
   
}


//MARK: -  iCarousel Delegate and DataSource

extension TariffCarouselView: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return tariffSlideList?.count ?? 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let carouselModel = tariffSlideList![index]
        let view: TariffCarouselCell = carouselCellView()
        view.delegate = self
        view.item = carouselModel
        
        if index != carousel.currentItemIndex {
            view.setUnselectedCellsInfo(item: carouselModel, index: index)
        } else {
            view.selectedSegmentIndex = selectedSegmentIndex ?? 0
            view.setSelectedCellInfo(item: carouselModel, vehicleModel: vehicleModel ?? VehicleModel(), index: index)
        }
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option) {
        case .spacing: return 0.15//0.5
        default: return value
        }
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        print(carousel.currentItemIndex)
        carousel.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        selectedSegmentIndex = 0
    }
}


//MARK: TariffCarouselCellDelegate
//MARK: ----------------------------
extension TariffCarouselView: TariffCarouselCellDelegate {
    
    func willChangeOption(optionIndex: Int, options: [TariffSlideModel]?) {
        let optionstr = tariffSlideViewModel.getOptionString(tariff: TariffState.allCases[tariffCarousel.currentItemIndex],
                                                             tariffSlideList:tariffSlideList ?? [],
                                                             index: optionIndex)
        delegate?.willChangeTariffOption(tariff: TariffState.allCases[tariffCarousel.currentItemIndex],
                                         optionstr: optionstr,
                                         optionIndex: optionIndex,
                                         options: options)
    }
    
    func showSearchView(optionIndex: Int, options: [TariffSlideModel]?) {
        let optionstr = tariffSlideViewModel.getOptionString(tariff: TariffState.allCases[tariffCarousel.currentItemIndex],
                                                             tariffSlideList:tariffSlideList ?? [],
                                                             index: optionIndex)
        delegate?.didPressConfirm(tariff: TariffState.allCases[tariffCarousel.currentItemIndex],
                                  optionIndex: optionIndex,
                                  optionstr: optionstr,
                                  options: options)
    }
    
    func didPressMore(tariffIndex: Int, optionIndex: Int) {
        delegate?.didPressMore(tariffIndex: tariffIndex, optionIndex: optionIndex)
    }
    
}
