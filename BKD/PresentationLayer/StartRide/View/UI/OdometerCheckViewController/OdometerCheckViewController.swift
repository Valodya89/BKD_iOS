//
//  OdometerCheckViewController.swift
//  OdometerCheckViewController
//
//  Created by Karine Karapetyan on 16-09-21.
//

import UIKit

class OdometerCheckViewController: UIViewController {

    @IBOutlet weak var mScrollV: UIScrollView!
    @IBOutlet weak var mStep2Lb: UILabel!
    @IBOutlet weak var mOdometCheckLb: UILabel!
    @IBOutlet weak var mKmLb: UILabel!
    @IBOutlet weak var mKmPriceLb: UILabel!
    
    @IBOutlet weak var mDescriptionLb: UILabel!
    
    @IBOutlet weak var mVehicleLastOdometeTitleLb: UILabel!
    
    @IBOutlet weak var mLastOdometeNumberLb: UILabel!
    
    @IBOutlet weak var mConfirmLastOdometRadioBtn: UIButton!
    
    @IBOutlet weak var mConfirmLastOdometeLb: UILabel!
    
    @IBOutlet weak var mInputManuallyRadioBtn: UIButton!
    
    @IBOutlet weak var mInputeManuallyLb: UILabel!
    
    @IBOutlet weak var mOdomateNumberTxtFl: UITextField!
    
    ///Open camera
    @IBOutlet weak var mOpenCameraContentV: UIView!
    @IBOutlet weak var mOpenCameraBtn: UIButton!
    
    @IBOutlet weak var mOdomateImgV: UIImageView!
    
   
    ///Start noew
    @IBOutlet weak var mStartNowContentV: UIView!
    
    @IBOutlet weak var mStartNowBtn: UIButton!
    
    @IBOutlet weak var mStartNowLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   //36
    //3

    @IBAction func confirmLastOdometer(_ sender: UIButton) {
    }
    
    
    @IBAction func inputManually(_ sender: UIButton) {
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
    }
    
    @IBAction func startRideSwipe(_ sender: UISwipeGestureRecognizer) {
    }
    @IBAction func startNow(_ sender: UIButton) {
    }
}
