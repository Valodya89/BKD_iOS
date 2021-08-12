//
//  CarouselViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 30-06-21.
//

import UIKit

class CarouselViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, StoryboardInitializable {
    
    var didChangeCategory: ((Int) -> Void)?
    var updateCarList: (([CarsModel]) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var items = CategoryCarouselData.categoryCarouselModel
    lazy var mainViewModel = MainViewModel()
    var carTypes:[CarTypes] = []
    
    var currentPage: Int = 0 {
        
        didSet {
            
            didChangeCategory?(currentPage)
            collectionView.reloadData()
            
            if carTypes.count > 0 {
                getCarsByType(carType: carTypes[currentPage])

            }
                
            //  collectionView.scrollToItem(index: self.currentPage)
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
        getCarTypes()
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
            getCarsByType(carType: carTypes[currentPage])
        }
    }
    
    func getCarsByType(carType: CarTypes) {
        mainViewModel.getCarsByTypes(fieldValue: carType.id) { (result) in
            print(result)
            self.updateCarList?(result)
        }
    }
    
    
    // MARK: - Card Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let item = carTypes[(indexPath as NSIndexPath).row]
        cell.setInfoCell(item: item, index: indexPath.item, currentPage: currentPage)
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
