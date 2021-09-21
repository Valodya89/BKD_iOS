//
//  EditReservationViewController.swift
//  EditReservationViewController
//
//  Created by Karine Karapetyan on 15-09-21.
//

import UIKit

class EditReservationViewController: UIViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var mEdidBySearchV: EditBySearchView!
    @IBOutlet weak var mAccessoriesBtn: UIButton!
    @IBOutlet weak var mAdditionalDriverBtn: UIButton!
    @IBOutlet weak var mCheckPriceBtn: UIButton!
    
    
    //MARK: -- Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: -- Actions
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func additionalDriver(_ sender: UIButton) {
        
        let myDriverVC = UIStoryboard(name: Constant.Storyboards.myDrivers, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.myDrivers) as! MyDriversViewController
       // myDriverVC.delegate = self
        self.navigationController?.pushViewController(myDriverVC, animated: true)
    }
    
    @IBAction func accessories(_ sender: UIButton) {
        
        let accessoriesVC = UIStoryboard(name: Constant.Storyboards.accessories, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.accessories) as! AccessoriesUIViewController
        //accessoriesVC.delegate = self
        self.navigationController?.pushViewController(accessoriesVC, animated: true)
    }
    
    @IBAction func checkPrice(_ sender: UIButton) {
        sender.setClickTitleColor(color_menu!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
         }
    }
}
