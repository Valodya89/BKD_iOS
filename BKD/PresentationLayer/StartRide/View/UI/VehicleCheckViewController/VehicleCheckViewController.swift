//
//  VehicleCheckViewController.swift
//  VehicleCheckViewController
//
//  Created by Karine Karapetyan on 17-09-21.
//

import UIKit

class VehicleCheckViewController: UIViewController, StoryboardInitializable {
    
   //MARK: --Outlets
    @IBOutlet weak var mStepTitleLb: UILabel!
    @IBOutlet weak var mVehicleCheckLb: UILabel!
    @IBOutlet weak var mDescriptionLb: UILabel!
    @IBOutlet weak var mFinishCheckLb: UIButton!
    @IBOutlet weak var mPageContentV: UIView!
    @IBOutlet weak var mPageControl: UIPageControl!
    @IBOutlet weak var mAddDamageContentV: UIView!
    @IBOutlet weak var mPageCollcetionV: UICollectionView!
    
    //MARK: --Variables
    private lazy  var addDamageVC = NewDamageViewController.initFromStoryboard(name: Constant.Storyboards.newDamage)
    let pageDataSours:[StartRideModel] = StartRideData.startRideModel
    var currentPageIndex = 0
    
    //MARK: --Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addDamageVC.view.frame = mAddDamageContentV.frame

    }
    
    
    func setupView() {
        mPageCollcetionV.register(VehicleDimageCollectionCell.nib(), forCellWithReuseIdentifier: VehicleDimageCollectionCell.identifier)
    }
    
    /// Add Damage child viewController
    func addDamageView() {
        
        addChild(addDamageVC)
        self.view.addSubview(addDamageVC.view)
        addDamageVC.didMove(toParent: self)
        addDamageVC.delegate = self
    }
    
    ///Remove AddDamage child ViewController
    private func removeAddDamageChildViewController() {
        addDamageVC.willMove(toParent: nil)
        addDamageVC.view.removeFromSuperview()
        addDamageVC.removeFromParent()
    }
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
   

   //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func finishCheck(_ sender: Any) {
    }
    
}


extension VehicleCheckViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        mPageControl.numberOfPages = pageDataSours.count
        mPageControl.isHidden = !(pageDataSours.count > 1)
        return pageDataSours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleDimageCollectionCell.identifier, for: indexPath) as!  VehicleDimageCollectionCell
        let item = pageDataSours[indexPath.item]
        cell.setCellInfo(item:item, index: indexPath.item, isAddCell: indexPath.item == pageDataSours.count - 1)
        cell.didPressAdd = {
            self.openCamera()
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 517)

    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
            let combinedItemWidth = (numberOfItems * flowLayout.itemSize.width) + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
            let padding = (collectionView.frame.width - combinedItemWidth) / 2
            return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        mPageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        mPageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}



//MARK: - UIImagePickerControllerDelegate
//MARK: --------------------------------
extension VehicleCheckViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
             return  }
        addDamageVC.mDamageImgV.image = image
        addDamageView()
        
    }
    
  
}

//MARK: -- NewDamageViewControllerDelegate
extension VehicleCheckViewController: NewDamageViewControllerDelegate {
    func didPressCancel() {
        removeAddDamageChildViewController()
    }
    
    func didPressConfirm() {
        addDamageVC.mConfirmBtn.backgroundColor = .clear
        removeAddDamageChildViewController()
        
    }
}
