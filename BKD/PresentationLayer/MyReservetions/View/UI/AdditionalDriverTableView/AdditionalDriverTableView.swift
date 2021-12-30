//
//  AdditionalDriverTableView.swift
//  AdditionalDriverTableView
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit

class AdditionalDriverTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var drivers:[DriverToRent]? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.register(AditionalDriverTableCell.nib(), forCellReuseIdentifier: AditionalDriverTableCell.identifier)
        self.separatorColor = UIColor.lightGray.withAlphaComponent(0.25)
        self.delegate = self
        self.dataSource = self
    }

    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  drivers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AditionalDriverTableCell.identifier, for: indexPath) as! AditionalDriverTableCell
        cell.setCellInfo(item: drivers![indexPath.row] , index: indexPath.row)
        if indexPath.row != drivers!.count - 1 {
       
            cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0);

            //tableView.separatorStyle = .none
        }
        
        return cell
    }

}
