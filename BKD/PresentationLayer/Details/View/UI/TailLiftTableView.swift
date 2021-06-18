//
//  TailLiftTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-06-21.
//

import UIKit

class TailLiftTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
        return TailLiftData.tailLiftModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TailLiftData.tailLiftModel[indexPath.row].title
        cell.textLabel?.textColor = color_navigationBar
        cell.textLabel?.font = font_search_cell
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = TailLiftData.tailLiftModel[indexPath.row].value
        label.textColor = color_navigationBar
        label.font = font_unselected_filter
        label.textAlignment = .center
        cell.accessoryView = label
        cell.backgroundColor = .clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tailLift_cell_height
    }
}
