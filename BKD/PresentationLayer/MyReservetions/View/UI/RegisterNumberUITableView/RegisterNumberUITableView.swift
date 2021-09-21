//
//  RegisterNumberUITableView.swift
//  RegisterNumberUITableView
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit

class RegisterNumberUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var registerNumberArr:[String]? = ["1-ZBF-401"]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.register(RegisterNumberTableCell.nib(), forCellReuseIdentifier: RegisterNumberTableCell.identifier)
        self.separatorColor = UIColor.lightGray.withAlphaComponent(0.25)
        self.delegate = self
        self.dataSource = self
    }

    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  registerNumberArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegisterNumberTableCell.identifier, for: indexPath) as! RegisterNumberTableCell
        cell.setCellInfo(item: registerNumberArr![indexPath.row])
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return detail_cell_height
//    }

}
