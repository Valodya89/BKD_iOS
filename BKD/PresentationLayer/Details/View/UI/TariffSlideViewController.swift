//
//  TariffSlideCollectionViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit

private let reuseIdentifier = "Cell"

class TariffSlideViewController: UIViewController, StoryboardInitializable {
    //MARK: Outlet
    @IBOutlet weak var mTariffSlideCollectionV: UICollectionView!
    @IBOutlet weak var mTariffSlideWidth: NSLayoutConstraint!
    //MARK: Variables
    var cellSpace: CGFloat = 5
    var isOpenDetails = false
    var tariffSlideArr:[TariffSlideModel] = TariffSlideData.tariffSlideModel
    
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    private func configureCollectionView(){
        // Register cell classes
        mTariffSlideCollectionV.register(TariffSlideCollectionViewCell.nib(), forCellWithReuseIdentifier: TariffSlideCollectionViewCell.identifier)
        //delegates
        mTariffSlideCollectionV.delegate = self
        mTariffSlideCollectionV.dataSource = self
       
    }
     
}

 
extension TariffSlideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    //MARK: -------------------------------
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tariffSlideArr.count//TariffSlideData.tariffSlideModel.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TariffSlideCollectionViewCell.identifier, for: indexPath) as! TariffSlideCollectionViewCell
        
        let model: TariffSlideModel = tariffSlideArr[indexPath.item]//TariffSlideData.tariffSlideModel[indexPath.item]

        if model.value != nil {
            cell.mDetailsBckgV.isHidden = false
            cell.mDetailTitleLb.text = model.title
            cell.mDetailValueLb.text = model.value
            cell.mDetailsBckgV.backgroundColor = color_menu
            cell.isUserInteractionEnabled = false
           
        } else {
            cell.mDetailsBckgV.isHidden = true
            cell.mTitleLb.text = model.title
            cell.containerV.backgroundColor = model.bckgColor
            cell.isUserInteractionEnabled = true
            cell.mTitleLb.textColor = (indexPath.item % 2 == 1) ? .white : color_main
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    //MARK: ------------------------------------
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       // if there is some slide open it will close
//        if (tariffSlideArr.count > TariffSlideData.tariffSlideModel.count) && !tariffSlideArr[indexPath.item].isOpenDetails {
//            tariffSlideArr = TariffSlideData.tariffSlideModel
//            collectionView.reloadData()
//        }
//        
        
        let currModel = tariffSlideArr[indexPath.item]
        let details = tariffSlideArr[indexPath.item].details!
        
        if  !currModel.isOpenDetails {
            // will open details cells
            var insertIndexPathsArr:[IndexPath] = []
            for i in (0..<details.count) {
                insertIndexPathsArr.append(IndexPath(item: indexPath.item + i + 1, section: 0))
                tariffSlideArr.insert(TariffSlideModel(title: details[i].title,
                                                                         bckgColor: details[i].bckgColor,
                                                                         value: details[i].value),
                                                        at: indexPath.item + i + 1)
            }
           
            collectionView.insertItems(at: insertIndexPathsArr)
        } else {
            // will close details cells
            var deleteIndexPathsArr:[IndexPath] = []

            for i in ((indexPath.item + 1)..<((indexPath.item + 1) + details.count - 1)) {
                deleteIndexPathsArr.append(IndexPath(item: i, section: 0))
            }
            let range = (indexPath.item + 1)...((indexPath.item + 1) + details.count - 1)
            tariffSlideArr.removeSubrange(range)
            collectionView.deleteItems(at: deleteIndexPathsArr)
        }
        collectionView.scrollToItem(at: indexPath,
                                    at: [.left],
                                    animated: true)
        tariffSlideArr[indexPath.item].isOpenDetails =  !currModel.isOpenDetails
}
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.bounds.width * 0.173913,
                       height: self.view.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpace
    }


}
