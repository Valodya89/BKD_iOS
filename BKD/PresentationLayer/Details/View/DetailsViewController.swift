//
//  DetailsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

class DetailsViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var carPhotosView: CarPhotosView!
    @IBOutlet weak var mCarInfoV: CarInfoView!
    @IBOutlet weak var mDetailsAndTailLiftV: DetailsAndTailLiftView!
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
   
    @IBOutlet weak var mDetailsTbV: DetailsTableView!
    @IBOutlet weak var mDetailsTableBckgV: UIView!
       @IBOutlet weak var mTailLiftTbV: TailLiftTableView!
    @IBOutlet weak var mTailLiftTableBckgV: UIView!
    
    @IBOutlet weak var mDetailsTbVHeight: NSLayoutConstraint!
    @IBOutlet weak var mTailLiftTbVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mReserveLb: UILabel!
    
    //MARK: Varables
    private lazy  var tariffSlideVC = TariffSlideViewController.initFromStoryboard(name: Constant.Storyboards.details)
    private  var tariffSlideY: CGFloat = 0
    private var lastContentOffset: CGFloat = 0
    private var isScrolled = false

    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if DetailsData.detailsModel.count > 10{
            mDetailsTbVHeight.constant = 400
        } else {
            mDetailsTbVHeight.constant = CGFloat(DetailsData.detailsModel.count) * detail_cell_height
        }
        if TailLiftData.tailLiftModel.count > 10 {
            mTailLiftTbVHeight.constant = 400
        } else {
            mTailLiftTbVHeight.constant = CGFloat(TailLiftData.tailLiftModel.count) * tailLift_cell_height
        }
        var bottomPadding:CGFloat  = 0
        let tariffSlideHeight = self.view.bounds.height * 0.08168
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            bottomPadding = window.safeAreaInsets.bottom
        }
        if UIScreen.main.nativeBounds.height <= 1334 {
            bottomPadding = 22
        }
        if !isScrolled {
            tariffSlideY = (self.view.bounds.height * 0.742574) - bottomPadding
            tariffSlideVC.view.frame = CGRect(x: 0,
                                              y: tariffSlideY,
                                              width: self.view.bounds.width,
                                              height: tariffSlideHeight)
        }
        
      // mScrollV.contentSize = CGSize(width: self.view.frame.width, height: 1300)

    }
    
    func setupView() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        configureViews()
        configureDelegates()
        addTariffSliedView()
    }
    private func configureViews () {
        mDetailsTableBckgV.setShadow(color: color_shadow!)
        mDetailsTableBckgV.layer.cornerRadius = 3
        mTailLiftTableBckgV.setShadow(color: color_shadow!)
        mTailLiftTableBckgV.layer.cornerRadius = 3
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        
    }
    func configureDelegates() {
        mDetailsAndTailLiftV.delegate = self
        mScrollV.delegate = self
    }
    
    func addTariffSliedView() {
        addChild(tariffSlideVC)
        self.view.addSubview(tariffSlideVC.view)
    }
    //MARK: ACTIONS
    //MARK: --------------------

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func accessories(_ sender: UIButton) {
    }
    @IBAction func additionalDriver(_ sender: UIButton) {
    }
}

 
//MARK: DetailsAndTailLiftViewDelegate
//MARK: ----------------------------------
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        if willOpen  {
            if self.mTailLiftTableBckgV.alpha == 1 {
                // will show Details tableView and close TailLift tableView
                    UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                        
                        self.mDetailsAndTailLiftV.mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                        self.mTailLiftTableBckgV.alpha = 0
                    }, completion: { [self]_ in
                        self.mTailLiftTableBckgV.isHidden = true
                        UIView.transition(with: self.mDetailsTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                            self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                            self.mDetailsTableBckgV.alpha = 1
                            self.mDetailsTableBckgV.isHidden = false
                        }, completion: nil)
                    })
                
            } else { // will show Details tableView
                UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                    self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                    self.mDetailsTableBckgV.alpha = 1
                    self.mDetailsTableBckgV.isHidden = false
                }, completion: nil)
            }
            
        } else if !willOpen { // will hide Details tableView
            UIView.transition(with: mDetailsTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                self.mDetailsTableBckgV.alpha = 0
            }, completion: {_ in
                self.mDetailsTableBckgV.isHidden = true
            })
        }
    }
    
    func didPressTailLift(willOpen: Bool) {
        // will show TailLift tableView
        if willOpen {
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 1
                self.mTailLiftTableBckgV.isHidden = false
            }, completion: nil)
        } else if !willOpen { // will hide TailLift tableView
            UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                self.mTailLiftTableBckgV.alpha = 0
            }, completion: {_ in
                self.mTailLiftTableBckgV.isHidden = true
            })
        }
    }
    
    
}

//MARK: UIScrollViewDelegate
//MARK: ----------------------------
extension DetailsViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        /// Change top view position and alpha
//
//        if tariffSlideVC.view.frame.origin.y <= tariffSlideY {
//            isScrolled = true
//            tariffSlideVC.view.frame.origin.y = -abs(tariffSlideY + scrollView.contentOffset.y)
////                CGRect(x: tariffSlideVC.view.frame.origin.x,
////                                              y: self.view.frame.height + 300,
////                                              width: tariffSlideVC.view.frame.width,
////                                              height: tariffSlideVC.view.frame.height)
////           tariffSlideVC.view.layoutIfNeeded()
//                //
//
//        } else {
//
//        }
//
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            isScrolled = true
            tariffSlideVC.view.frame.origin.y = abs(tariffSlideY + scrollView.contentOffset.y)
            print("move up")
      //  }
//        else if (self.lastContentOffset < scrollView.contentOffset.y) {
//            // move down
//
//            print("move down")
//            tariffSlideVC.view.frame.origin.y = -abs(tariffSlideVC.view.frame.origin.y  - scrollView.contentOffset.y)
//        }

        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}
