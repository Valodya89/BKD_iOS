//
//  myPersonalInfoTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit

class MyPersonalInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    public var isEdit: Bool = false
    public var mainDriverList: [MainDriverModel]?
    var didPressChangePhoto:((Int)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        configuredelegates()
        registerTableCells()
    }
    
    /// Register table view cells
    func registerTableCells() {
        self.register(PersonalInfoTableCell.nib(), forCellReuseIdentifier: PersonalInfoTableCell.identifier)
        self.register(MailBoxNumberTableCell.nib(), forCellReuseIdentifier: MailBoxNumberTableCell.identifier)
        self.register(PhotosTableViewCell.nib(), forCellReuseIdentifier: PhotosTableViewCell.identifier)
    }
    
    ///Configure delegates
    func configuredelegates() {
        self.delegate = self
        self.dataSource = self
    }
    
    
    //MARK: -- UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDriverList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = mainDriverList![indexPath.row]
        if item.isMailBox {
            return mailBoxTableViewCell(item: item, indexPath: indexPath)
        } else if item.isPhoto {
            return photosTableViewCell(item: item,
                                       indexPath: indexPath)
        }
        return personalInfoTableViewCell(item: item, indexPath: indexPath)
    }
    
    
    ///Init personal table cell
    func personalInfoTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> PersonalInfoTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: PersonalInfoTableCell
                                        .identifier, for: indexPath) as! PersonalInfoTableCell
        cell.setCellInfo(item: item, index: indexPath.row, isEdit: isEdit)
        return cell
    }
    
    ///Init mail box table cell
    func mailBoxTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> MailBoxNumberTableCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: MailBoxNumberTableCell
                                        .identifier, for: indexPath) as! MailBoxNumberTableCell
        cell.setCellInfo(item: item, index: indexPath.row, isEdit: isEdit)
        return cell
    }
    
    ///Init Photos table cell
    func photosTableViewCell(item: MainDriverModel, indexPath: IndexPath) -> PhotosTableViewCell {
        let cell =
        self.dequeueReusableCell(withIdentifier: PhotosTableViewCell
                                        .identifier, for: indexPath) as! PhotosTableViewCell
        cell.setCellInfo(item: item, index: indexPath.row, isEdit: isEdit)
        
        cell.didPressChangePhoto = { index in
            self.didPressChangePhoto?(index)
        }
        return cell
        
    }
    
}
