//
//  ReserveTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-06-21.
//

import UIKit

class ReserveTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(ReserveTableViewCell.nib(), forCellReuseIdentifier: ReserveTableViewCell.identifier)
        self.delegate = self
        self.dataSource = self
    }

    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReserveData.reserveModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReserveTableViewCell.identifier, for: indexPath) as! ReserveTableViewCell
        let model = ReserveData.reserveModel[indexPath.row]
        cell.setCellInfo(item: model)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return detail_cell_height
//    }

}
