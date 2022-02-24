//
//  SubMenuTableView.swift
//  BKD
//
//  Created by Karine Karapetyan on 12-01-22.
//

import UIKit

class SubMenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    public var languageList: [Language]?
    public var isLanguage = false
    public var isContactUs = false
    var openChat:(()->())?
    var changeLanguage:((String?)->())?

    
    override func awakeFromNib() {
        self.register(SubmenuTableCell.nib(), forCellReuseIdentifier: SubmenuTableCell.identifier)
        self.delegate = self
        self.dataSource = self
    }
    
    //MARK: -- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLanguage {
            return languageList?.count ?? 0
        } else if isContactUs {
            return contactUsList.count
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: SubmenuTableCell.identifier, for: indexPath) as! SubmenuTableCell
         if isLanguage {
             cell.mImgV.image =  languageList?[indexPath.row].imageFlag
             cell.mTitleBtn.setTitle(languageList?[indexPath.row].name, for: .normal)
         } else if isContactUs {
             cell.mImgV.isHidden = true
             cell.mTitleBtn.setTitle(contactUsList[indexPath.row], for: .normal)
         }
        return cell
    }
    
    
    //MARK: -- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isContactUs {
            switch indexPath.row {
            case 0:
                let settings = ApplicationSettings.shared.settings
                phoneClick(phone: settings?.metadata.CallBKDPhone ?? "+00 (0)0 000 00 00")
                break
            case 1:
                openChat?()
                break
            default: break
            }
        } else {
            changeLanguage?(languageList?[indexPath.row].id)
        }
    }
    
    //Call by phone number
    func phoneClick(phone: String) {
        let num = phone.replacingOccurrences(of: " ", with: "")
        if let callUrl = URL(string: "tel://\(num)"), UIApplication.shared.canOpenURL(callUrl) {
                    UIApplication.shared.open(callUrl)
        }
    }
}
