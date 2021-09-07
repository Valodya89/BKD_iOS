//
//  CarPhotosView.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

protocol CarPhotosViewDeleagte: AnyObject {
    func didChangeCarImage(_ img: UIImage)
}

class CarPhotosView: UIView {
    //MARK: Outlet
    @IBOutlet weak var mCarImagesBckgV: UIView!
    @IBOutlet weak var mScrollLeftBtn: UIButton!
    @IBOutlet weak var mScrollRightBtn: UIButton!
    @IBOutlet weak var mTowBarBtn: UIButton!
    @IBOutlet weak var mTowBarLB: UILabel!
    @IBOutlet weak var mTowBarBckgV: UIView!
    @IBOutlet weak var mImagePagingCollectionV: UICollectionView!
    @IBOutlet weak var mImagesBottomCollectionV: UICollectionView!
    
    weak var delegate: CarPhotosViewDeleagte?
    
    //MARK: Variables
    var currentCarPhotoItem: Int = 0
    var carImagesList: [UIImage] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView()  {
        mCarImagesBckgV.setShadow(color: color_shadow!)
        mCarImagesBckgV.setBorder(color: color_shadow!, width: 0.25)
        mCarImagesBckgV.layer.cornerRadius = 3
        mScrollRightBtn.isHidden = carImagesList.count > 1 ? false : true
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
    
    private func setImageCellInfo (cell: UICollectionViewCell, img: UIImage) {
        removeOldImageFromCell(cell: cell)
        var imgV = UIImageView()
        imgV = UIImageView(frame: CGRect(x: mImagePagingCollectionV.bounds.width * 0.166,
                                         y: mImagePagingCollectionV.bounds.height * 0.057,
                                         width: mImagePagingCollectionV.bounds.width * 0.55/*0.4951*/,
                                         height: mImagePagingCollectionV.bounds.height - 15))
        imgV.contentMode = .scaleAspectFit
        imgV.image = img
        cell.contentView.addSubview(imgV)
    }
    
    private func removeOldImageFromCell(cell: UICollectionViewCell) {
        for view in cell.contentView.subviews {
            if view.isKind(of: UIImageView.self) {
                view.removeFromSuperview()
            }
        }
    }
    private func scrollToIndex(index:Int) {
        let rect = mImagePagingCollectionV.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
        mImagePagingCollectionV.scrollRectToVisible(rect!, animated: true)
        delegate?.didChangeCarImage(carImagesList[index])
    }
    
    ///Will show or hide previous and next arrow buttons
    private func showOrHideScrollButtons () {
        if currentCarPhotoItem == 0 {
            mScrollLeftBtn.isHidden = true
            if carImagesList.count > 1  {
                mScrollRightBtn.isHidden = false
            }
        } else if currentCarPhotoItem == carImagesList.count - 1 {
            mScrollRightBtn.isHidden = true
            if currentCarPhotoItem == 1 {
                mScrollLeftBtn.isHidden = false
            }
                
        } else {
            mScrollLeftBtn.isHidden = false
            mScrollRightBtn.isHidden = false
        }
    }
    
    
    ///collection view will move to current position
    private func movetoPositionBottomCollectionView() {
        mImagesBottomCollectionV.reloadData()
        mImagesBottomCollectionV.scrollToItem(at:NSIndexPath(item: currentCarPhotoItem, section: 0) as IndexPath , at: .centeredHorizontally, animated: true)
        delegate?.didChangeCarImage(carImagesList[currentCarPhotoItem])//CarsData.carModel[currentCarPhotoItem].carImage)
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
        movetoPositionBottomCollectionView()
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        print ("currentCarPhotoItem =  \(currentCarPhotoItem)")
        if currentCarPhotoItem <= carImagesList.count - 1 {
            scrollToIndex(index: currentCarPhotoItem + 1)
            currentCarPhotoItem += 1
        }
        showOrHideScrollButtons()
        movetoPositionBottomCollectionView()
    }
}

extension CarPhotosView: UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carImagesList.count//CarsData.carModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == mImagePagingCollectionV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            setImageCellInfo(cell: cell, img: carImagesList[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesBottomCollectionViewCell.identifier, for: indexPath) as! ImagesBottomCollectionViewCell

            cell.setCellInfo(img: carImagesList[indexPath.row], currentImageIndex: currentCarPhotoItem, index: indexPath.row)
                        
            return cell
        }
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
            movetoPositionBottomCollectionView()
        }
    }
    
}
