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
    @IBOutlet weak var mTariffCarouselV: TariffCarouselView!
    @IBOutlet weak var mDetailsTableBckgV: UIView!
       @IBOutlet weak var mTailLiftTbV: TailLiftTableView!
    @IBOutlet weak var mTailLiftTableBckgV: UIView!
    
    @IBOutlet weak var mDetailsTbVHeight: NSLayoutConstraint!
    @IBOutlet weak var mTailLiftTbVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mReserveBckgV: UIView!
    
    @IBOutlet weak var mReserveBtn: UIButton!
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
        setTableViewsHeight()
        setTariffSlideViewFrame()
    }
    
    func setupView() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        configureViews()
        configureDelegates()
        addTariffSliedView()
    }
    
    /// set height to details or tailLift tableView
    func  setTableViewsHeight() {
        if DetailsData.detailsModel.count > 11{
            mDetailsTbVHeight.constant = 11 * detail_cell_height
        } else {
            mDetailsTbVHeight.constant = CGFloat(DetailsData.detailsModel.count) * detail_cell_height
        }
        mDetailsTbV.frame.size = CGSize(width: mDetailsTbV.frame.size.width, height: mDetailsTbVHeight.constant)
        self.view.layoutIfNeeded()
        if TailLiftData.tailLiftModel.count > 10 {
            mTailLiftTbVHeight.constant = 10 * tailLift_cell_height
        } else {
            mTailLiftTbVHeight.constant = CGFloat(TailLiftData.tailLiftModel.count) * tailLift_cell_height
        }
    }
    
    ///set frame to Tariff Slide View
    func setTariffSlideViewFrame() {
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
    }
    private func configureViews () {
        mDetailsTbV.setShadow(color: color_shadow!)
        mDetailsTbV.layer.cornerRadius = 3
        mTailLiftTableBckgV.setShadow(color: color_shadow!)
        mTailLiftTableBckgV.layer.cornerRadius = 3
        mAccessoriesBtn.layer.cornerRadius = 8
        mAdditionalDriverBtn.layer.cornerRadius = 8
        mReserveBckgV.setGradientWithCornerRadius(cornerRadius: 0.0, startColor:color_Offline_bckg!, endColor:color_Offline_bckg!.withAlphaComponent(0.85) )
        mReserveBckgV.roundCorners(corners: [.topRight], radius: 20)
        
    }
    func configureDelegates() {
        mDetailsAndTailLiftV.delegate = self
        mTariffCarouselV.delegate = self
        mScrollV.delegate = self
    }
    
    /// Add child view
    func addTariffSliedView() {
        addChild(tariffSlideVC)
        self.view.addSubview(tariffSlideVC.view)

       // self.view.bringSubviewToFront(mDetailsTbV)

    }
    
    /// ScrollView will scroll to bottom
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: mScrollV.contentSize.height - mScrollV.bounds.height + mScrollV.contentInset.bottom)
        mScrollV.setContentOffset(bottomOffset, animated: true)
    }
    //MARK: ACTIONS
    //MARK: --------------------

    ///Navigation controller will back to pravius controller
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    @IBAction func additionalDriver(_ sender: UIButton) {
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        let recerve = UIStoryboard(name: Constant.Storyboards.reserve, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.reserve) as! ReserveViewController
        self.navigationController?.pushViewController(recerve, animated: true)
    }
}

 
//MARK: DetailsAndTailLiftViewDelegate
//MARK: ----------------------------------
extension DetailsViewController: DetailsAndTailLiftViewDelegate {
    
    func didPressDetails(willOpen: Bool) {
        if willOpen  {
            scrollToBottom()
            if self.mTailLiftTableBckgV.alpha == 1 {
                // will show Details tableView and close TailLift tableView
                    UIView.transition(with: mTailLiftTableBckgV, duration: 1, options: [.transitionCurlUp,.allowUserInteraction], animations: { [self] in
                        
                        self.mDetailsAndTailLiftV.mTailLiftDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi * -2))
                        self.mTailLiftTableBckgV.alpha = 0
                    }, completion: { [self]_ in
                        self.mTailLiftTableBckgV.isHidden = true
                        UIView.transition(with: self.mDetailsTbV, duration: 1, options: [.transitionCurlDown,.allowUserInteraction], animations: { [self] in
                            self.mDetailsAndTailLiftV.mDetailsDropDownImgV.rotateImage(rotationAngle: CGFloat(Double.pi))
                            self.mDetailsTbV.alpha = 1
                            self.mDetailsTbV.isHidden = false
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
        scrollToBottom()

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


//MARK: TariffCarouselViewDelegate
//MARK: ----------------------------
extension DetailsViewController: TariffCarouselViewDelegate {
    func didPressMore() {
        let moreVC = UIStoryboard(name: Constant.Storyboards.more, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.more) as! MoreViewController
        self.navigationController?.pushViewController(moreVC, animated: true)
    }
}
//MARK: UIScrollViewDelegate
//MARK: ----------------------------
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ( scrollView.contentOffset.y == 0) {
            // move up
            if isScrolled {
                isScrolled = false
                UIView.animate(withDuration: 1.0) { [self] in
                    self.tariffSlideVC.view.frame.origin.y -= 500
                    mTariffCarouselV.alpha = 0.0
                    self.tariffSlideVC.view.layoutIfNeeded()
                } completion: { [self]_ in
                    self.mTariffCarouselV.isHidden = true
                }
            }
        } else if (scrollView.contentOffset.y > 0) {
            // move down
            if !isScrolled {
                isScrolled = true
                mTariffCarouselV.isHidden = false
                UIView.animate(withDuration: 1.0) { [self] in
                    self.mTariffCarouselV.alpha = 1
                    self.tariffSlideVC.view.frame.origin.y += 500
                    self.tariffSlideVC.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
}
