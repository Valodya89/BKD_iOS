//
//  AddressNameView.swift
//  BKD
//
//  Created by Karine Karapetyan on 24-05-21.
//

import UIKit
protocol AddressNameViewControllerDelegate: AnyObject {
    func didPressOk()
    func didPressRoute()
    func didPressUserLocation()

}
class AddressNameViewController: UIViewController, StoryboardInitializable {
    //MARK: - Outlets

    @IBOutlet weak var mMapPickerImgV: UIImageView!
    @IBOutlet weak var mCurrentLocationBtn: UIButton!
    @IBOutlet weak var mAddressNameLb: UILabel!
    @IBOutlet weak var mRouteBtn: UIButton!
    @IBOutlet weak var mOkBtn: UIButton!
    @IBOutlet weak var mBackgroundV: UIView!
//    var didPressOk:(() -> Void)?
//    var didPressRoute:(() -> Void)?
//    var didPressUserLocation:(() -> Void)?
    //MARK: Variables
    weak var delegate: AddressNameViewControllerDelegate?
    
    //MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    func setUpView() {
        mBackgroundV.layer.cornerRadius = 20
        mBackgroundV.layer.masksToBounds = true
        mRouteBtn.setBorder(color: color_btn_pressed!, width: 1)
        mOkBtn.setBorder(color: color_btn_pressed!, width: 1)
        mOkBtn.backgroundColor = color_btn_pressed
        mOkBtn.layer.cornerRadius = 8
        mRouteBtn.layer.cornerRadius = 8
        

    }

    //MARK: Actions
    @IBAction func ok(_ sender: UIButton) {
        sender.backgroundColor = color_btn_pressed
        mRouteBtn.backgroundColor = .clear
        delegate?.didPressOk()

    }
    @IBAction func route(_ sender: UIButton) {
        sender.backgroundColor = color_btn_pressed
        mOkBtn.backgroundColor = .clear
        delegate?.didPressRoute()
    }
    @IBAction func currentLocation(_ sender: UIButton) {
        delegate?.didPressUserLocation()
    }
}
