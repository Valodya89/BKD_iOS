//
//  DamageSidesTableView.swift
//  DamageSidesTableView
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit


protocol DamageSidesTableViewDelegate: AnyObject {
    func willOpenPicker(textFl: UITextField)
    func didPressTakePhoto()
    func didPressAddMore()
}

class DamageSidesTableView: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: -- Variables
    var damageSideArr:[DamagesSideModel] = [DamagesSideModel(damageSide: nil,
                                                             damageImg: nil,
                                                             isTakePhoto: true)]
    weak var damageSidesDelegate: DamageSidesTableViewDelegate?
    
    
    //MARK: -- Life cicle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func setupView() {
        self.delegate = self
        self.dataSource = self
        self.register(DamageSideTableCell.nib(), forCellReuseIdentifier: DamageSideTableCell.identifier)
    }

    
    
    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  damageSideArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DamageSideTableCell.identifier, for: indexPath) as! DamageSideTableCell
        cell.setCallInfo(itemList: damageSideArr, index: indexPath.row)
        
        cell.willOpenPicker = {textFl in
            self.damageSidesDelegate?.willOpenPicker(textFl: textFl)
        }
        cell.didPressTakePhoto = {
            self.damageSidesDelegate?.didPressTakePhoto()
        }
        cell.didPressAddMore = {
            self.damageSidesDelegate?.didPressAddMore()

        }
        return cell
    }
}

    
