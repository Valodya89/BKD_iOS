//
//  MyReservationsViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu

class MyReservationsViewController: BaseViewController {
    var menu: SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
    }
    
    @IBAction func menu(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    

}


// MARK: UICollectionViewDelegate, UICollectionViewDataSource
//MARK: -----------------
extension MyReservationsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyDriverCollectionViewCell.identifier, for: indexPath) as!  MyDriverCollectionViewCell
        let item = additionalDrivers[indexPath.item]
        cell.setCellInfo(item:item, index: indexPath.item)
        
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    //MARK: -------------------------------------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width,
                      height: mydriver_cell_height)
    }
    
}
