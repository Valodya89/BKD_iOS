//
//  ReserveTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 18-06-21.
//

import UIKit

class ReserveTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var accessories:[AccessoriesEditModel]? = nil
    var drivers:[MyDriversModel]? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(ReserveTableViewCell.nib(), forCellReuseIdentifier: ReserveTableViewCell.identifier)
        self.separatorColor = UIColor.lightGray.withAlphaComponent(0.25)
        self.delegate = self
        self.dataSource = self
    }

    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let _ = accessories  {
            count += accessories!.count
        }
        if let _ = drivers  {
            count += drivers!.count
        }
        return  count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReserveTableViewCell.identifier, for: indexPath) as! ReserveTableViewCell
        
        if (drivers?.count ?? 0 > 0) &&
            indexPath.row < drivers!.count{
            
           if indexPath.row == 0 {
                cell.mHeadreLb.isHidden = false
                cell.mHeadreLb.text = Constant.Texts.additionalDriver
           }
            cell.setDriversCell(item: (drivers?[indexPath.row])!, index: indexPath.row)
            cell.separatorInset = UIEdgeInsets.zero
        } else if accessories?.count ?? 0 > 0 &&
                    drivers?.count ?? 0 > 0 &&
                    (indexPath.row < (accessories!.count + drivers!.count)) {
            
            if indexPath.row == drivers!.count {
                cell.mHeadreLb.isHidden = false
                 cell.mHeadreLb.text = Constant.Texts.accessories
            }
            cell.setAccessoriesCell(item: (accessories?[indexPath.row - drivers!.count])!, index: indexPath.row)
            
        } else if accessories?.count ?? 0 > 0 {
            if indexPath.row == 0 {
                cell.mHeadreLb.isHidden = false
                 cell.mHeadreLb.text = Constant.Texts.accessories
            }
            cell.setAccessoriesCell(item: (accessories?[indexPath.row])!, index: indexPath.row)
        }
            
            
        
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return detail_cell_height
//    }

}
