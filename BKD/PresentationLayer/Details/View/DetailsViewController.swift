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
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    
    @IBOutlet weak var mReserveLb: UILabel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if DetailsData.detailsModel.count > 5 {
            mDetailsTbVHeight.constant = 330
        } else {
            mDetailsTbVHeight.constant = CGFloat(DetailsData.detailsModel.count * 44)
        }
        if TailLiftData.tailLiftModel.count > 5 {
            mTailLiftTbVHeight.constant = 310
        } else {
            mTailLiftTbVHeight.constant = CGFloat(TailLiftData.tailLiftModel.count * 44)
        }
    }
    
    func setupView() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)
        configureViews()
        configureDelegates()
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
