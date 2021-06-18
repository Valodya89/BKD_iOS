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
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        mRightBarBtn.image = img_bkd
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        configureDelegates()
    }
    
  
    
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccessoriesCollectionViewCell.identifier, for: indexPath) as!  AccessoriesCollectionViewCell
        cell.setCellInfo()
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
    func didPressAdd(addValue: Double, isIncrease: Bool) {
        var value: Double = 0.0
        if isIncrease {
            value = Double(truncating: mPriceLb.formattToNumber()) + addValue
        } else {
            value = Double(truncating: mPriceLb.formattToNumber()) - addValue
        }
        let newValue = String(value).replacingOccurrences(of: ".", with: ",")
        mPriceLb.text = newValue
    }
    
    
}
