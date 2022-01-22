//
//  DetailsTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-06-21.
//

import UIKit

class DetailsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var detailList: [DetailsModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
      //  self.setBorder(color: color_shadow!, width: 0.25)
        self.layer.cornerRadius = 3
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.separatorStyle = .none
        self.allowsSelection = false
    }
    
    
    //MARK: -- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = detailList[indexPath.row].image
        cell.textLabel?.textColor = color_alert_txt
        cell.textLabel?.font = font_details_title
        cell.backgroundColor = .clear
        cell.imageView?.setTintColor(color: color_email!)
        if detailList[indexPath.row].title == Constant.Texts.keyDiesel {
            cell.textLabel?.text = Constant.Texts.diesel
        } else if detailList[indexPath.row].title == Constant.Texts.keyPetrol {
            cell.textLabel?.text = Constant.Texts.petrol
        } else if detailList[indexPath.row].title == Constant.Texts.manual {
            cell.textLabel?.text = Constant.Texts.transmissionManual
        } else if detailList[indexPath.row].title == Constant.Texts.automatic {
            cell.textLabel?.text = Constant.Texts.transmissionAutomatic
        } else {
            cell.textLabel?.text = detailList[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return detail_cell_height
    }
}
