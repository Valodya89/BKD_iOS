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
    var collectionData: [CarsModel]?
    

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
    
    ///Set cell info
    func setCellInfo(carsList: [String : [CarsModel]?]?, carType: CarTypes) {
        let item:[CarsModel] = carsList![carType.id]! ?? []
        mCategoryNameLb.text = carType.name
        collectionData =  item
    }
    
}


extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  collectionData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        guard let _ = collectionData else { return cell }
        let item: CarsModel = collectionData![indexPath.row]
        cell.setCellInfo(item: item)
        return cell
    }
    
//    //MARK: UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width * 0.342995, height: self.frame.height * 0.820809)//0.183168
//    }
    
}
