//
//  TariffSlideCollectionViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit

enum TariffState: String, CaseIterable {
    case hourly = "Hourly"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case flexible = "Flexible"
}

protocol TariffSlideViewControllerDelegate: AnyObject {
    func didPressTariffOption(tariff: TariffState, optionIndex:Int)
}

class TariffSlideViewController: UIViewController, StoryboardInitializable {
    //MARK: Outlet
    @IBOutlet weak var mTariffSlideCollectionV: UICollectionView!
    @IBOutlet weak var mTariffSlideWidth: NSLayoutConstraint!
    //MARK: Variables
    var cellSpace: CGFloat = 5
    var isOpenDetails = false
    var tariffSlideList:[TariffSlideModel]?
    var currTariff:[Tariff] = []
    
    let tariffSlideViewModel: TariffSlideViewModel = TariffSlideViewModel()
    weak var delegate: TariffSlideViewControllerDelegate?
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
   
    
    ///Configure CollectionView
    private func configureCollectionView(){
        // Register cell classes
        mTariffSlideCollectionV.register(TariffSlideCollectionViewCell.nib(), forCellWithReuseIdentifier: TariffSlideCollectionViewCell.identifier)
        //delegates
        mTariffSlideCollectionV.delegate = self
        mTariffSlideCollectionV.dataSource = self
        
    }
    
    /// will open tariff options from cell
    private func openTariffOptions (options: [TariffSlideModel], index: Int) {
        
        var insertIndexPathsArr:[IndexPath] = []
        for i in (0..<options.count) {
            insertIndexPathsArr.append(IndexPath(item: index + i + 1, section: 0))
            tariffSlideList?.insert(TariffSlideModel(type: options[i].type,
                                                   name:options[i].name,
                                                   bckgColor:options[i].bckgColor,
                                                     typeColor: options[i].typeColor,
                                                   value: options[i].value, isItOption: true),
                                  at: index + i + 1)
        }
        
        mTariffSlideCollectionV.insertItems(at: insertIndexPathsArr)
    }
    
    /// will close options from cell
    private func closeTariffOptions(options: [TariffSlideModel], index: Int) {
        
        var deleteIndexPathsArr:[IndexPath] = []
        for i in ((index + 1)..<((index + 1) + options.count - 1)) {
            deleteIndexPathsArr.append(IndexPath(item: i, section: 0))
        }
        let range = (index + 1)...((index + 1) + options.count - 1)
        tariffSlideList?.removeSubrange(range)
        mTariffSlideCollectionV.deleteItems(at: deleteIndexPathsArr)
    }
    
    /// will selecte tariff option cell
    private func selectTariffOption(model: TariffSlideModel, currTariff: [Tariff]) {
        let optionIndex = tariffSlideViewModel.getIndexOfOption(tariffArr: currTariff, model: model)
        
        delegate?.didPressTariffOption(tariff: TariffState(rawValue: model.type!)!, optionIndex: optionIndex)
    }
}


extension TariffSlideViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    //MARK: -------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tariffSlideList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TariffSlideCollectionViewCell.identifier, for: indexPath) as! TariffSlideCollectionViewCell
        
        let model: TariffSlideModel = tariffSlideList?[indexPath.item] ?? TariffSlideModel()
        if model.value == nil || model.type == Constant.Texts.flexible {
            cell.setTariffSlideCellInfo(item: model, index: indexPath.item)
        } else {
            cell.setOptionsTariffSlideCellInfo(item: model, index:indexPath.item )
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    //MARK: ------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currModel = tariffSlideList?[indexPath.item]
        if  currModel?.options?.count ?? 0 > 0 {
            currTariff = currModel?.tariff ?? []
        }
        guard let options =  currModel?.options else {
            //select tariff option
            selectTariffOption(model: currModel!, currTariff: currTariff)
            return
        }
        
        if  !currModel!.isOpenOptions {// open tariff options
            openTariffOptions(options: options, index: indexPath.item)
            
        } else { // clode tariff options
            closeTariffOptions(options: options, index: indexPath.item)
        }
        collectionView.scrollToItem(at: indexPath,
                                    at: [.left],
                                    animated: true)
        tariffSlideList?[indexPath.item].isOpenOptions =  !currModel!.isOpenOptions
        
        
    }
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: self.view.bounds.width * 0.173913,
//                      height: self.view.bounds.height)
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpace
    }
    
    
}
