//
//  DetailsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 09-06-21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var carPhotosView: CarPhotosView!
    
    @IBOutlet weak var mLeftBarBtn: UIBarButtonItem!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        mRightBarBtn.image = #imageLiteral(resourceName: "bkd").withRenderingMode(.alwaysOriginal)

    }
    
    //MARK: ACTIONS
    //MARK: --------------------

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

    }
}


