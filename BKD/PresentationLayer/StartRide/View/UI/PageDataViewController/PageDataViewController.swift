//
//  PageDataViewController.swift
//  PageDataViewController
//
//  Created by Karine Karapetyan on 17-09-21.
//

import UIKit

class PageDataViewController: UIViewController {

    //MARK: --Outlets
    
    ///Damage image
    @IBOutlet weak var mImagePageV: UIView!
    @IBOutlet weak var mCameraImgV: UIImageView!
    @IBOutlet weak var mCarImgV: UIImageView!
    @IBOutlet weak var mDamageGradientV: UIView!
    @IBOutlet weak var mDamageNameLb: UILabel!
    
    ///Add image
    @IBOutlet weak var mAddImagePageV: UIView!
    @IBOutlet weak var mGradientV: UIView!
    @IBOutlet weak var mDescriptionLb: UILabel!
    @IBOutlet weak var mAddDamageLb: UILabel!
    @IBOutlet weak var mAddBtn: UIButton!
    
    //MARK: -- Variables
    var index: Int?
    var carImg: UIImage?
    var damageName: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mDamageNameLb.text = damageName
        mCarImgV.image = carImg
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
