//
//  CategoryTableViewCell.swift
//  BKD
//
//  Created by Karine Karapetyan on 19-05-21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBOutlet weak var mCategoryNameLb: UILabel!
    @IBOutlet weak var mCategoryCollectionV: UICollectionView!
    var collectionData: CategoryModel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    func setUpView(){
        mCategoryCollectionV.dataSource = self
        mCategoryCollectionV.delegate = self
        self.mCategoryCollectionV.register(CategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  collectionData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let categoryData: CategoryCollectionData = (collectionData?.data[indexPath.row])!
        
      
        cell.mCarNameLb.text = categoryData.carName
        cell.mCarImgV.image = categoryData.carImg
        cell.mBlurBackgV.isHidden = categoryData.isCarExist
        cell.mBlurCarNameLb.isHidden = categoryData.isCarExist
        cell.mInfoBckgV.isHidden = !categoryData.isCarExist

        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
   /* func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.342995, height: self.frame.height * 0.820809)//0.183168
    }*/
    
}
