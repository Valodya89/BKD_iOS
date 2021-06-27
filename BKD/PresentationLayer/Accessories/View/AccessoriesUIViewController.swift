//
//  AccessoriesUIViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit

class AccessoriesUIViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mAccessoriesCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    var usersAccessories: [AccessoriesModel] = []
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        configureDelegates()
    }
    
  
   ///configure Delegates
    private func configureDelegates() {
        mAccessoriesCollectionV.delegate = self
        mAccessoriesCollectionV.dataSource = self
    }
    
    //MARK: ACTION
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension AccessoriesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AccessoriesData.accessoriesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccessoriesCollectionViewCell.identifier, for: indexPath) as!  AccessoriesCollectionViewCell
        cell.setCellInfo(item: AccessoriesData.accessoriesModel[indexPath.row])
        cell.delegate = self
        return cell
    }
    
//    //MARK: UICollectionViewDelegateFlowLayout
//    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width,
                      height: self.view.bounds.height * 0.153465)
    }
}

//MARK: AccessoriesCollectionViewCellDelegate
//MARK: ------------------------
extension AccessoriesUIViewController: AccessoriesCollectionViewCellDelegate {
    func didPressAdd(accessories: AccessoriesModel, isIncrease: Bool) {
        var value: Double = 0.0
        if isIncrease {
            value = Double(truncating: mPriceLb.formattToNumber()) + accessories.accessoryPrice!
        } else {
            value = Double(truncating: mPriceLb.formattToNumber()) - accessories.accessoryPrice!
        }
        let newValue = String(value).replacingOccurrences(of: ".", with: ",")
        mPriceLb.text = newValue
        usersAccessories.append(accessories)
    }
    
    
}
