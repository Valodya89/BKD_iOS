//
//  MyDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 16-06-21.
//

import UIKit

class MyDriversViewController: UIViewController {
//MARK: Outlets
    @IBOutlet weak var mMyDriverCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mAddDriverBckgV: UIView!
    @IBOutlet weak var mAddDriverLb: UILabel!
    @IBOutlet weak var mAddBtn: UIButton!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        mRightBarBtn.image = img_bkd
        mTotalPriceBckgV.setShadow(color: color_shadow!)
        mAddDriverBckgV.layer.cornerRadius = mAddDriverBckgV.frame.height/2
        mAddBtn.layer.cornerRadius =  mAddBtn.frame.height/2
        configureDelegates()
    }
     
     private func configureDelegates() {
        mMyDriverCollectionV.delegate = self
        mMyDriverCollectionV.dataSource = self
     }
    //MARK: ACTIONS
    //MARK: ----------------
    @IBAction func addDriver(_ sender: UIButton) {
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension MyDriversViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        cell.setCellInfo()
        cell.delegate = self
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.bounds.width,
//                      height: self.view.bounds.height * 0.0816832)
//    }
    
}


extension MyDriversViewController: MyDriverCollectionViewCellDelegate {
    func didPressSelect() {
        
    }
    
}
