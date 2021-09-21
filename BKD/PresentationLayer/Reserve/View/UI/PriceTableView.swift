//
//  PriceTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 29-06-21.
//

import UIKit

class PriceTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var pricesArr: [PriceModel] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.register(PriceTableViewCell.nib(), forCellReuseIdentifier: PriceTableViewCell.identifier)
        self.layer.cornerRadius = 3
        self.setShadow(color: color_shadow!)
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
    }

    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return pricesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as! PriceTableViewCell
        cell.setCellInfo(item: pricesArr[indexPath.row])
        return cell
    }
}
