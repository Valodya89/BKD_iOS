//
//  MarkNewAddressViewController.swift
//  MarkNewAddressViewController
//
//  Created by Karine Karapetyan on 04-10-21.
//

import UIKit

protocol MarkNewAddressViewControllerDelegate: AnyObject {
    func didPressUserLocation()
    func didPressContinue(place: String)

}


class MarkNewAddressViewController: UIViewController, StoryboardInitializable {

    //MARK: -- Outlets
    @IBOutlet weak var mContinueV: ConfirmView!
    @IBOutlet weak var mBackgroundV: UIView!
    @IBOutlet weak var mNewAddressLb: UILabel!
    
    //MARK: Variables
    weak var delegate: MarkNewAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        handlerContinue()
    }
    
    func setupView()  {
        mBackgroundV.layer.cornerRadius = 20
        
    }
    

    @IBAction func userLocation(_ sender: Any) {
        delegate?.didPressUserLocation()

    }
    
    func handlerContinue() {
        mContinueV.didPressConfirm = {
            self.delegate?.didPressContinue(place: self.mNewAddressLb.text ?? "")
        }
    }
}
