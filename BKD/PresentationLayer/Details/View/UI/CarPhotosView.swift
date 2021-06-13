//
//  CarPhotosView.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

class CarPhotosView: UIView {
    //MARK: Outlet
    @IBOutlet weak var mCarImagesBckgV: UIView!
    @IBOutlet weak var mScrollLeftBtn: UIButton!
    @IBOutlet weak var mScrollRightBtn: UIButton!
    @IBOutlet weak var mTowBarBtn: UIButton!
    @IBOutlet weak var mTowBarLB: UILabel!

    @IBOutlet weak var mImagePagingCollectionV: UICollectionView!
    @IBOutlet weak var mImagesBottomCollectionV: UICollectionView!
    //MARK: Variables
    var currentCarPhotoItem: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView()  {
        mCarImagesBckgV.setShadow(color: color_shadow!)
        mCarImagesBckgV.setBorder(color: color_shadow!, width: 0.25)
        mCarImagesBckgV.layer.cornerRadius = 3
        configureDelegates()
        configureCollectionViews()
    }
    
    private func configureDelegates() {
        mImagePagingCollectionV.delegate = self
        mImagePagingCollectionV.dataSource = self
        mImagesBottomCollectionV.delegate = self
        mImagesBottomCollectionV.dataSource = self
    }
    
    private func configureCollectionViews() {
        mImagePagingCollectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        mImagesBottomCollectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func scrollToIndex(index:Int) {
        let rect = mImagePagingCollectionV.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
        mImagePagingCollectionV.scrollRectToVisible(rect!, animated: true)
    }
    
    private func showOrHideScrollButtons () {
        if currentCarPhotoItem == 0 {
            mScrollLeftBtn.isHidden = true
        } else if currentCarPhotoItem == CarsData.carModel.count - 1 {
            mScrollRightBtn.isHidden = true
        } else {
            mScrollLeftBtn.isHidden = false
            mScrollRightBtn.isHidden = false
        }
    }
    
    private func movetoPossitionBottomCollectionView() {
        mImagesBottomCollectionV.reloadData()
        mImagesBottomCollectionV.scrollToItem(at:NSIndexPath(item: currentCarPhotoItem, section: 0) as IndexPath , at: .centeredHorizontally, animated: true)
    }
    //MARK: ACTIONS
    //MARK: -----------------
    @IBAction func scrollLeft(_ sender: UIButton) {
        print ("currentCarPhotoItem =  \(currentCarPhotoItem)")
        
        if currentCarPhotoItem > 0 {
            scrollToIndex(index: currentCarPhotoItem - 1)
            currentCarPhotoItem -= 1
        }
        showOrHideScrollButtons()
        movetoPossitionBottomCollectionView()
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        print ("currentCarPhotoItem =  \(currentCarPhotoItem)")
        if currentCarPhotoItem <= CarsData.carModel.count - 1 {
            scrollToIndex(index: currentCarPhotoItem + 1)
            currentCarPhotoItem += 1
        }
        showOrHideScrollButtons()
        movetoPossitionBottomCollectionView()
    }
}

extension CarPhotosView: UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CarsData.carModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for view in cell.contentView.subviews {
            if view.isKind(of: UIImageView.self) {
                view.removeFromSuperview()
            }
        }
        
        var imgV = UIImageView()
        if collectionView == mImagePagingCollectionV {
            imgV = UIImageView(frame: CGRect(x: collectionView.bounds.width * 0.166,
                                             y: collectionView.bounds.height * 0.057,
                                             width: collectionView.bounds.width * 0.55/*0.4951*/,
                                             height: collectionView.bounds.height - 15))
        } else {
            imgV = UIImageView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: self.bounds.width * 0.227053 ,
                                             height: self.bounds.height * 0.264))
            imgV.backgroundColor = color_background!
            imgV.layer.cornerRadius = 3
            imgV.setShadowByBezierPath(color: color_shadow!)
            //imgV.setShadow(color: color_shadow!)
        }
        
        imgV.contentMode = .scaleAspectFit
        imgV.image = CarsData.carModel[indexPath.row].carImage
        cell.contentView.addSubview(imgV)
        if collectionView == mImagesBottomCollectionV && currentCarPhotoItem == indexPath.item {
                cell.contentView.makeBorderWithCornerRadius(radius: 3, borderColor: color_navigationBar!, borderWidth: 0.5)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mImagePagingCollectionV {
            return CGSize(width: collectionView.frame.width,
                          height: collectionView.frame.height)
        }
       return CGSize(width: self.bounds.width * 0.227053,
                     height: self.bounds.height * 0.264)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == mImagePagingCollectionV ? 0 : 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mImagesBottomCollectionV {
            currentCarPhotoItem = indexPath.item
            collectionView.reloadData()
            scrollToIndex(index: currentCarPhotoItem)
            showOrHideScrollButtons()
        }
    }
    
}


extension CarPhotosView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mImagePagingCollectionV  {
            let pageWidth = scrollView.frame.size.width
            currentCarPhotoItem = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            showOrHideScrollButtons()
            movetoPossitionBottomCollectionView()

        }
    }
    
}
