//
//  OfflineViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 03-06-21.
//

import UIKit




protocol OfflineViewControllerDelegate: AnyObject {
    func dismiss()
}
class OfflineViewController: UIViewController, StoryboardInitializable  {
    
    //MARK: Outlets
    @IBOutlet weak var mNavigationBarV: UIView!
    @IBOutlet weak var mOfflineV: UILabel!
    @IBOutlet weak var mCloseBtn: UIButton!
    @IBOutlet weak var mNoticeBckgV: UIView!
    @IBOutlet weak var mNoticeLb: UILabel!
    @IBOutlet weak var mEmailErrorLb: UILabel!
    @IBOutlet weak var mEmailTextFl: UITextField!
    @IBOutlet weak var mSuccessBckgV: UIView!
    @IBOutlet weak var mMessaeStatusLb: UILabel!
    @IBOutlet weak var mThankYouLb: UILabel!
    @IBOutlet weak var mEmailBottom: NSLayoutConstraint!
    //MARK: Variables
    weak var delegate: OfflineViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        mNavigationBarV.setShadowByBezierPath(color: .black)
        mEmailTextFl.setPadding()
        mSuccessBckgV.roundCornersWithBorder(corners: [.topLeft],
                                             radius: 10,
                                             borderColor: .white,
                                             borderWidth: 2.0)
        mSuccessBckgV.roundCornersWithBorder(corners: [.bottomRight],
                                             radius: 10,
                                             borderColor: .white,
                                             borderWidth: 2.0)
        mSuccessBckgV.roundCornersWithBorder(corners: [.topRight],
                                             radius: 10,
                                             borderColor: .white,
                                             borderWidth: 2.0)
        mSuccessBckgV.roundCornersWithBorder(corners: [.bottomLeft],
                                             radius: 10,
                                             borderColor: .white,
                                             borderWidth: 2.0)
        mEmailBottom.constant = mEmailErrorLb.frame.size.height
       // mSuccessBckgV.setBorder(color: .white, width: 2)
    }
    
   
   
    
    

    // MARK: ACTIONS
    // MARK: ------------------------
    @IBAction func close(_ sender: Any) {
        delegate?.dismiss()

    }

}


