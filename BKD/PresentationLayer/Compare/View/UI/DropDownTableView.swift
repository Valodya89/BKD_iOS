//
//  DtopDownTableView.swift
//  DtopDownTableView
//
//  Created by Karine Karapetyan on 06-10-21.
//

import UIKit

class DropDownTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableHeight: NSLayoutConstraint!
    
    public var categoryList: [CarTypes]?
    public var carList: [CarModel]?

    public var isCategory:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setBorder(color: color_shadow!, width: 0.25)
        self.layer.cornerRadius = 3
        self.delegate = self
        self.dataSource = self
        self.register(CompareCategoryTableCell.nib(), forCellReuseIdentifier: CompareCategoryTableCell.identifier)
        self.separatorStyle = .none
        self.allowsSelection = false
    }
    
    ///Update table height
    public func updateTableHeight(willOpen:Bool) {
        
        UIView.animate(withDuration: 0.5) {
            self.mTableHeight.constant = willOpen ? self.contentSize.height : 0.0
            self.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isCategory ? categoryList?.count ?? 0 : carList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompareCategoryTableCell.identifier, for: indexPath) as! CompareCategoryTableCell
        if isCategory {
            cell.setCategoryCellInfo(item: categoryList![indexPath.row])
        } else {
            cell.setVehicleCellInfo(item: carList![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return height68
       }
    
}
