//
//  AccessoriesUIViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 15-06-21.
//

import UIKit


protocol AccessoriesUIViewControllerDelegate: AnyObject {
    func addedAccessories(_ isAdd: Bool, totalPrice: Double)
}
class AccessoriesUIViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var mAccessoriesCollectionV: UICollectionView!
    @IBOutlet weak var mTotalPriceBckgV: UIView!
    @IBOutlet weak var mTotalPriceLb: UILabel!
    @IBOutlet weak var mPriceLb: UILabel!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    
    let accessoriesViewModel = AccessoriesViewModel()
    var totalPrice:Double = 0
    weak var delegate:AccessoriesUIViewControllerDelegate?
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
        
        self.delegate?.addedAccessories(self.mPriceLb.text == "0.0" ? false : true , totalPrice: totalPrice)
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension AccessoriesUIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return additionalAccessories.count//AccessoriesData.accessoriesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccessoriesCollectionViewCell.identifier, for: indexPath) as!  AccessoriesCollectionViewCell
        let item = additionalAccessories[indexPath.row]
        cell.setCellInfo(item: item,index: indexPath.row)
        
        if item.isAdded {
            totalPrice += Double(item.accessoryCount!) * item.accessoryPrice!
            self.mPriceLb.text = String(totalPrice)

        }
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
    
    func didChangeCount(cellIndex: Int, count: Int) {
        additionalAccessories[cellIndex].accessoryCount = count
    }

    func didPressAdd(isAdd: Bool, cellIndex: Int) {
        additionalAccessories[cellIndex].isAdded = isAdd
    }
    
    
    ///increase or decrease Accessory
    func increaseOrDecreaseAccessory(accessoryPrice: Double,
                     isIncrease: Bool) {
        totalPrice = (mPriceLb.text! as NSString).doubleValue
        
        accessoriesViewModel.getTotalAccesories(accessoryPrice: accessoryPrice, totalPrice: totalPrice, isIncrease: isIncrease) { (totalValue) in
            self.mPriceLb.text = totalValue
            self.totalPrice = (totalValue as NSString).doubleValue
        }
    }
    
    
}

