//
//  OnRideTableView.swift
//  OnRideTableView
//
//  Created by Karine Karapetyan on 24-09-21.
//

import UIKit

class OnRideTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var didPressAddDamage:(()->Void)?
    var didPressSwitchDriver:(()->Void)?
    var didPressMap:(()->Void)?

    var onRideArr:[OnRideModel]? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(AdvancedWithOnRideCell.nib(), forCellReuseIdentifier: AdvancedWithOnRideCell.identifier)
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    
    
    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  onRideArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdvancedWithOnRideCell.identifier, for: indexPath) as! AdvancedWithOnRideCell
        cell.setCellInfo(item: onRideArr![indexPath.row])
        cell.didPressAddDamage = {
            self.didPressAddDamage?()
        }
        cell.didPressSwitchDriver = {
            self.didPressSwitchDriver?()
        }
        cell.didPressMap = {
            self.didPressMap?()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height130
    }
    
    
}
