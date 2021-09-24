//
//  VehicleCheckViewController.swift
//  VehicleCheckViewController
//
//  Created by Karine Karapetyan on 17-09-21.
//

import UIKit
import SwiftUI

class VehicleCheckViewController: UIViewController, StoryboardInitializable {
    
   //MARK: --Outlets
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mStepTitleLb: UILabel!
    @IBOutlet weak var mVehicleCheckLb: UILabel!
    @IBOutlet weak var mDescriptionLb: UILabel!
    @IBOutlet weak var mFinishCheckBtn: UIButton!
    @IBOutlet weak var mPageContentV: UIView!
    @IBOutlet weak var mAdditionalChargesLb: UILabel!
    @IBOutlet weak var mPageControl: UIPageControl!
    @IBOutlet weak var mAddDamageContentV: UIView!
    @IBOutlet weak var mPageCollcetionV: UICollectionView!
    
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mAddDamageCenterY: NSLayoutConstraint!
    
    //MARK: --Variables

    private lazy  var addDamageVC = NewDamageViewController.initFromStoryboard(name: Constant.Storyboards.newDamage)
    var pageDataSours:[StartRideModel] = StartRideData.startRideModel
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
        mFinishCheckBtn.setGradientWithCornerRadius(cornerRadius: 8.0, startColor: color_gradient_register_start!, endColor: color_gradient_register_end!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        configurePageControl()
        mRightBarBtn.image = img_bkd
        mFinishCheckBtn.disable()
        mPageCollcetionV.register(VehicleDimageCollectionCell.nib(), forCellWithReuseIdentifier: VehicleDimageCollectionCell.identifier)
        
    }
   
    ///Configure page control
    func configurePageControl() {
        mPageControl.numberOfPages = pageDataSours.count

        if #available(iOS 14.0, *) {
            mPageControl.preferredIndicatorImage = UIImage(named: "unselect_radiobutton")
            mPageControl.setIndicatorImage(UIImage(named: "select_radiobutton"), forPage: 0)
            mPageControl.pageIndicatorTintColor = color_chat_placeholder!
            mPageControl.currentPageIndicatorTintColor = color_chat_placeholder!
        }
    }
    
    ///register For KeyboardNotifications
   private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: Keyboard NSNotification
    //MARK: ---------------------------
    
    @objc func keyboardWillShow (notification: NSNotification) {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size

        UIView.animate(withDuration: duration as! TimeInterval) {
            self.mAddDamageCenterY.constant -= keyboardSize.height / 3
        }
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        UIView.animate(withDuration: duration as! TimeInterval) {
            self.mAddDamageCenterY.constant = 0
        }
        self.view.layoutIfNeeded()
       self.view.setNeedsLayout()
    }
    
    /// Add Damage child viewController
    func addDamageView() {
        
        addChild(addDamageVC)
        self.view.addSubview(addDamageVC.view)
        addDamageVC.didMove(toParent: self)
        addDamageVC.mDemageTxtFl.text = nil
        addDamageVC.mConfirmBtn.disable()
        addDamageVC.delegate = self
    }
    
    ///Remove AddDamage child ViewController
    private func removeAddDamageChildViewController() {
        addDamageVC.willMove(toParent: nil)
        addDamageVC.view.removeFromSuperview()
        addDamageVC.removeFromParent()
    }
    
    ///Open camera
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    ///Open OdometerCheck controller
    func goToOdometerCheck() {
        let odometerCheckVC = OdometerCheckViewController.initFromStoryboard(name: Constant.Storyboards.odometerCheck)
        self.navigationController?.pushViewController(odometerCheckVC, animated: true)
    }
   

   //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func finishCheck(_ sender: Any) {
        goToOdometerCheck()
    }
    
}


extension VehicleCheckViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
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
        return mAddDamageContentV.frame.size

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if #available(iOS 14.0, *) {
            mPageControl?.setIndicatorImage(UIImage(named: "unselecte_page"), forPage: mPageControl!.currentPage)
        }
          
        mPageControl?.currentPage = Int(scrollView.contentOffset.x / (view.bounds.width * 0.746377))
        
        if #available(iOS 14.0, *) {
            mPageControl?.setIndicatorImage(UIImage(named: "selecte_page"), forPage: mPageControl!.currentPage)
        }
           print("mPageControl?.currentPage = \(mPageControl?.currentPage)")
           enableFinishCheck()
       }

       func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

           mPageControl?.currentPage = Int(scrollView.contentOffset.x / (view.bounds.width * 0.746377))
           enableFinishCheck()
       }
    
    
   
    private func enableFinishCheck() {
        if mPageControl?.currentPage == pageDataSours.count - 1 {
            mAdditionalChargesLb.isHidden = false
            mFinishCheckBtn.enable()
        } else {
            mAdditionalChargesLb.isHidden = true
            mFinishCheckBtn.disable()
        }
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
        
        BKDAlert().showAlert(on: self, title: nil, message: Constant.Texts.cancelDamage, messageSecond: nil, cancelTitle: Constant.Texts.back, okTitle: Constant.Texts.yesCancel) {
            self.addDamageVC.mCancelBtn.backgroundColor = .clear
        } okAction: {
            self.addDamageVC.mCancelBtn.backgroundColor = .clear
            self.removeAddDamageChildViewController()
        }
    }
    
    func didPressConfirm() {
        addDamageVC.mConfirmBtn.backgroundColor = .clear
        removeAddDamageChildViewController()
        
        let startRide = StartRideModel(damageImg: addDamageVC.mDamageImgV.image, damageName: addDamageVC.mDemageTxtFl.text)
        if pageDataSours[0].damageImg == img_camera {
            pageDataSours[0] = startRide
        } else {
            pageDataSours.insert(startRide, at: pageDataSours.count - 1)
        }
        mPageCollcetionV.reloadData()
    }
}
