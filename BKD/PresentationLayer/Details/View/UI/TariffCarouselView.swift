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
    func didPressFuelConsuption(isCheck: Bool)
    func didPressConfirm(tariff: TariffState, optionIndex: Int, optionstr: String)
    func willChangeTariffOption(tariff: TariffState, optionIndex: Int)
}

class TariffCarouselView: UIView {
    
   public var tariffSlideList:[TariffSlideModel]?

    private var tariffCarouselCellV: TariffCarouselCell?
    private let tariffSlideViewModel = TariffSlideViewModel()
    weak var delegate: TariffCarouselViewDelegate?
    var selectedSegmentIndex: Int?
    
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

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        carousel.reloadData()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}


//MARK: TariffCarouselCellDelegate
//MARK: ----------------------------
extension TariffCarouselView: TariffCarouselCellDelegate {
    
    func willChangeOption(optionIndex: Int) {
        var optionIndex = optionIndex
        if TariffState.allCases[tariffCarousel.currentItemIndex] == .monthly {
            optionIndex = 0
        }
        delegate?.willChangeTariffOption(tariff: TariffState.allCases[tariffCarousel.currentItemIndex], optionIndex: optionIndex)
    }
    
    func showSearchView(optionIndex: Int) {
        let optionstr = tariffSlideViewModel.getOptionString(tariff: TariffState.allCases[tariffCarousel.currentItemIndex], index: optionIndex)
        delegate?.didPressConfirm(tariff: TariffState.allCases[tariffCarousel.currentItemIndex], optionIndex: optionIndex, optionstr: optionstr)
    }
    
    func didPressMore(tariffIndex: Int, optionIndex: Int) {
        delegate?.didPressMore(tariffIndex: tariffIndex, optionIndex: optionIndex)
    }
    
    func didPressFuelConsuption(isCheck: Bool) {
        delegate?.didPressFuelConsuption(isCheck: isCheck)
    }
}
