//
//  StopRideVehicleImageTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 23-12-21.
//

import UIKit

class StopRideVehicleImageTableView:  UITableView, UITableViewDelegate, UITableViewDataSource {
        
        var defects:[Defect?] = []
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.register(VehiclePhotoTableViewCell.nib(), forCellReuseIdentifier: VehiclePhotoTableViewCell.identifier)
            self.delegate = self
            self.dataSource = self
        }

        //MARK: UITableViewDataSource
        //MARK: ----------------------------------
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  defects.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: VehiclePhotoTableViewCell.identifier, for: indexPath) as! VehiclePhotoTableViewCell
            cell.setInfoCell(item: defects[indexPath.row])
            return cell
        }

}
