//
//  LeftViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 05-05-21.
//

import UIKit

class LeftViewController: UITableViewController {
    
    //MARK: Variables
        var currentCelIndexPathRow : Int?
        var isLanguageListOpen:Bool = false
    
    //MARK: Life cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        addPrivacyPolice()
  
    }
    
    private func configureTableView () {
        tableView.register(LeftTableViewCell.nib(), forCellReuseIdentifier: LeftTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "background_menu")
        tableView.separatorStyle = .none
    }
  
    private func addPrivacyPolice () {
        //Add Privacy Policy
        let privacyV = PrivacyPoliceView()
        self.addChild(privacyV)
        self.view.addSubview(privacyV.view)
        
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom
        privacyV.view.frame = CGRect(x: 17, y: self.view.bounds.height - 90 - bottomPadding , width: 200, height: 60)
    }
    
    private func animateArrow (arrowImgV:UIImageView, rotationAngle: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            arrowImgV.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
    
    func hiddeDropDown(subCell: UIView) {
        isLanguageListOpen = false
        let seconds = 0.20
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            subCell.isHidden = true
        }
    }
  

    //MARK: UITableViewDataSource
    //MARK: ------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuData.menuModel.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftTableViewCell.identifier, for: indexPath) as! LeftTableViewCell
        if indexPath.row > 0 {
            let menuModel: MenuModel =  MenuData.menuModel[indexPath.row - 1 ]
            cell.img?.image = UIImage(named: menuModel.imageName)
            cell.lbl?.text =  menuModel.title
            cell.dropDownBtn.setImage(#imageLiteral(resourceName: "dropDown"), for: .normal)
            cell.backgroundColor = UIColor(named: "background_menu")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if indexPath.row == 2  {
                cell.dropDownBtn.isHidden = false
            } else if indexPath.row == 3 {
                cell.mNotificationSwictch.isHidden = false
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customV = UIView()
        customV.backgroundColor = UIColor(named: "background_menu")
        
        let profileImg = UIImageView(image:#imageLiteral(resourceName: "profile"))
        profileImg.frame =  CGRect(x: tableView.frame.size.width/2 - profileImg.frame.size.width/2 , y: 20, width: profileImg.frame.size.width, height: profileImg.frame.size.height)
        
        let userLb = UILabel()
        userLb.text = "Name Surname"
        userLb.textColor = .white
        userLb.frame =  CGRect(x: 5 , y: profileImg.frame.size.height + 13, width: tableView.frame.size.width - 10, height: profileImg.frame.size.height)
        userLb.textAlignment = .center
        userLb.font = UIFont(name: Constant.FontNames.sfproDodplay_light, size: 18)
        
        let lineV = UIView()
        lineV.backgroundColor = UIColor(red: 92.0/255, green: 111.0/255, blue: 138.0/255, alpha: 1.0)
        lineV.frame =  CGRect(x: 0 , y: 110, width: tableView.frame.size.width - 30, height: 1)
        
        customV.addSubview(profileImg)
        customV.addSubview(userLb)
        customV.addSubview(lineV)
        
        return customV
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if currentCelIndexPathRow == indexPath.row &&  indexPath.row == 2 {
            currentCelIndexPathRow = nil
            return 186
        }
        return 50

    }
    
    //MARK: UITableViewDelegate
    //MARK: ------------------------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController:UIViewController?
        let dropDownCell:LeftTableViewCell = tableView.cellForRow(at: indexPath) as! LeftTableViewCell
        switch indexPath.row {
        case 1:
            viewController = UIStoryboard(name: Constant.Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.aboutUs) as! AboutUsViewController
            navigationController?.pushViewController(viewController!, animated: true)
            
            break
        case 2:
            let cell:LeftTableViewCell = tableView.cellForRow(at: indexPath) as! LeftTableViewCell
            
            if isLanguageListOpen {
                currentCelIndexPathRow = nil
                animateArrow(arrowImgV: cell.dropDownBtn.imageView!, rotationAngle: CGFloat(Double.pi * -2))
                hiddeDropDown(subCell: cell.mSettingsV)
            } else {
                currentCelIndexPathRow = indexPath.row
                animateArrow(arrowImgV: cell.dropDownBtn.imageView!, rotationAngle: CGFloat(Double.pi))
                cell.mSettingsV.isHidden = false
                isLanguageListOpen = true
            }
            
            tableView .beginUpdates()
            tableView.endUpdates()
            
            break
        case 3:
            //Notifications
            break
        case 4:
            // faq
            break
        case 5:
            // Contact us
            break
        case 6:
            // Log out
            break
        default:
            viewController = UIStoryboard(name: Constant.Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.main) as! MainViewController
            break
        }
    }
    
    
        
}
