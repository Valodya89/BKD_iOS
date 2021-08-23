//
//  CarouselViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-06-21.
//

import UIKit
import AVFoundation


class CarouselViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, StoryboardInitializable {
    
    var didChangeCategory: ((Int) -> Void)?
    var updateCarList: (([CarsModel]) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = CategoryCarouselData.categoryCarouselModel
    lazy var mainViewModel = MainViewModel()
    var carTypes:[CarTypes]?
    var carTypeImages:[UIImage]?
    
    var currentPage: Int = 0 {
        didSet {
            didChangeCategory?(currentPage)
            collectionView.reloadData()
            
            guard let _ = carTypes else { return }
            getCarsByType(carType: carTypes![currentPage])
            //  collectionView.scrollToItem(index: self.currentPage)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
            AudioServicesPlaySystemSound(1157)
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        collectionView.alwaysBounceHorizontal = true
        self.currentPage = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        carTypes = ApplicationSettings.shared.carTypes
        guard let _ = carTypes else {
            getCarTypes()
            return }
        //getCarsByType(carType: carTypes![currentPage])
      
    }
    
    fileprivate func setupLayout() {
        let floawLayout = collectionView.collectionViewLayout as! UPCarouselFlowLayout
        floawLayout.itemSize = CGSize(width: 101, height: 111)
        floawLayout.scrollDirection = .horizontal
        floawLayout.spacingMode = .overlap(visibleOffset: 117)
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 0.7
        collectionView.collectionViewLayout = floawLayout
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func getCarTypes()  {
        mainViewModel.getCarTypes { [self] (result) in
            carTypes = result
            collectionView.reloadData()
            guard let _ = carTypes else {return}
            ApplicationSettings.shared.carTypes = carTypes
                getCarsByType(carType: carTypes![currentPage])
            self.getCarsByType()
            self.getCarTypeImages()
        }
    }
    
    func getCarTypeImages() {
        mainViewModel.getTypeImages(carTypes: carTypes!) { (result) in
            self.carTypeImages = result
            self.collectionView.reloadData()
        }
    }
    
    func getCarsByType(carType: CarTypes) {
        mainViewModel.getCarsByTypes(fieldValue: carType.id) { (result) in
            print(result)
            
            self.updateCarList?(result)
        }
    }
    
    
    /// Get all cars by type
    private func getCarsByType() {
        guard let _ = ApplicationSettings.shared.carsList else {
            CategoryViewModel().getCarsByTypes(carTypes:  carTypes!) { (cars) in
                guard let _ = cars else {return}
                ApplicationSettings.shared.carsList = cars!
            }
            return
        }
    }
    
    
    // MARK: - Card Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = carTypeImages else {
            return 0
        }
        return carTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        guard let item = carTypes?[(indexPath as NSIndexPath).row] else { return cell }
        cell.setInfoCell(item: item, typeImages: carTypeImages!, index: indexPath.item, currentPage: currentPage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        
        print("pageSide = \(pageSide)")
        print("offset = \(offset)")
        
    }
    
}


//extension UICollectionView {
//    func scrollToItem(index: Int) {
//        let contentOffset = CGFloat(floor(self.contentOffset.x + (self.bounds.size.width * CGFloat(index))))
//        self.moveToFrame(contentOffset: contentOffset)
//    }
//
//    func scrollToPreviousItem() {
//        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
//        self.moveToFrame(contentOffset: contentOffset)
//    }
//
//    func moveToFrame(contentOffset : CGFloat) {
//        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
//    }
//}
