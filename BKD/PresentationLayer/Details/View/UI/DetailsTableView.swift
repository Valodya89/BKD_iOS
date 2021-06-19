//
//  DetailsTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 10-06-21.
//

import UIKit

class DetailsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
        self.setBorder(color: color_shadow!, width: 0.25)
        self.layer.cornerRadius = 3
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.separatorStyle = .none
        self.allowsSelection = false
    }
    
    
    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailsData.detailsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = DetailsData.detailsModel[indexPath.row].image
        cell.textLabel?.text = DetailsData.detailsModel[indexPath.row].title
        cell.textLabel?.textColor = color_navigationBar
        cell.textLabel?.font = font_details_title
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return detail_cell_height
    }
}