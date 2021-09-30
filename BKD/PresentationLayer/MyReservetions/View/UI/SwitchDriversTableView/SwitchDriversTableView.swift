//
//  SwitchDriversTableView.swift
//  SwitchDriversTableView
//
//  Created by Karine Karapetyan on 28-09-21.
//

import UIKit

protocol SwitchDriversTableViewDelegate: AnyObject {
    func didPressCell(item: MyDriversModel)
}

class SwitchDriversTableView: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: -- Variables
    weak var switchDriversDelegate: SwitchDriversTableViewDelegate?
    var switchDriversList:[MyDriversModel] = MyDriversData.myDriversModel
    
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.delegate = self
        self.dataSource = self
        self.layer.cornerRadius = 25
        
        self.register(AditionalDriverTableCell.nib(), forCellReuseIdentifier: AditionalDriverTableCell.identifier)
    }

    
    
    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  switchDriversList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AditionalDriverTableCell.identifier, for: indexPath) as! AditionalDriverTableCell
        let item = switchDriversList[indexPath.row]
        cell.isSwitchDriver = true
        cell.setCellInfo(item: item , index: indexPath.row)
        cell.mAdditionalDriverLb.isHidden = true
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchDriversDelegate?.didPressCell(item: switchDriversList[indexPath.row])
    }
}

    
 
