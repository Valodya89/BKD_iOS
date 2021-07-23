//
//  BancontactView.swift
//  BKD
//
//  Created by Karine Karapetyan on 22-07-21.
//

enum BancontactCard: Int {
    case ing
    case bnp
    case kbc
}
import UIKit

class BancontactView: UIView {

    @IBOutlet weak var mContentV: UIView!
    @IBOutlet weak var mTitleLb: UILabel!
    @IBOutlet weak var mBancksCollectionV: UICollectionView!
    @IBOutlet weak var mContentVBottom: NSLayoutConstraint!
    
    var didPressBancontactCard:((BancontactCard) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        
    }
    
    func  setUpView() {
        mContentV.layer.cornerRadius = 22
        
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BancontactView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bancontactList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BancontactCollectionViewCell.identifier, for: indexPath as IndexPath) as! BancontactCollectionViewCell
                
        cell.mCardImgV.image = bancontactList[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didPressBancontactCard?(BancontactCard(rawValue: indexPath.item)!)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.width * 0.135

    }
    

}
