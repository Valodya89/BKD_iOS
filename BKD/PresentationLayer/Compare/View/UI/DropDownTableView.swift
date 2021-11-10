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
    public var carList: [CarsModel]?
    public var tableState:TableState = .close
    
    var didSelectCategory:((CarTypes?)->Void)?
    var didSelectFirstVehicle:((CarsModel?)->Void)?
    var didSelectSecondVehicle:((CarsModel?)->Void)?
    var didCloseTable:(()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.setBorder(color: color_shadow!, width: 0.5)
        self.layer.cornerRadius = 3
        self.delegate = self
        self.dataSource = self
        self.register(CompareCategoryTableCell.nib(), forCellReuseIdentifier: CompareCategoryTableCell.identifier)
        self.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableState == .category {
            return categoryList?.count ?? 0
        }
        return carList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompareCategoryTableCell.identifier, for: indexPath) as! CompareCategoryTableCell
        switch tableState {
        case .category:
            cell.setCategoryCellInfo(item: categoryList![indexPath.row])
        case .close: break
        default:
            cell.setVehicleCellInfo(item: carList![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return height68
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableState {
        case .category:
            didSelectCategory?(categoryList?[indexPath.row])
        case .firstVehicle:
            didSelectFirstVehicle?(carList?[indexPath.row])
        case .secondVehicle:
            didSelectSecondVehicle?(carList?[indexPath.row])
        case .close: break
        }
        didCloseTable?()
    }
}
