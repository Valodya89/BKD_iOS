//
//  SearchAttributesUIView.swift
//  BKD
//
//  Created by Karine Karapetyan on 11-05-21.
//

import UIKit

class LocationDropDownView: UIView, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var mPickUpLocationTableView: UITableView!
    @IBOutlet weak var mheightLayoutConst: NSLayoutConstraint!
    
    let cellSpacingHeight:CGFloat = 14.0

    var didSelectSeeMap: (() -> Void)?
    var didSelectLocation: ((String) -> Void)?

    var hiddenLocationList: (() -> Void)?


    override func awakeFromNib() {
        superview?.awakeFromNib()
        self.setUpView()
    }
    
    func setUpView() {
        // TableView
        mPickUpLocationTableView.separatorStyle = .none
        mPickUpLocationTableView.dataSource = self
        mPickUpLocationTableView.delegate = self
        mPickUpLocationTableView.register(DropDownTableViewCell.nib(),
                                          forCellReuseIdentifier: DropDownTableViewCell.identifier)
       

    }
        
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DropDownData.dropDownModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier) as! DropDownTableViewCell
        let dropDown: DropDownModel = DropDownData.dropDownModel[indexPath.row]
        cell.backgroundColor = .clear
        cell.mLocationNameLb.backgroundColor = .clear
        cell.mLocationNameLb.textColor = UIColor(named: "navigationBar")
        cell.mLocationNameLb.text = dropDown.locationName
        cell.mSeeMapBtn.tag = indexPath.row
        cell.mSeeMapBtn.addTarget(self, action: #selector(seeMapPressed(sender:)), for: .touchUpInside)
        
        //Enabled imageView
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(seeMapPressed))
        cell.mMapImgV.addGestureRecognizer(tapImg)
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DropDownTableViewCell
        cell.mLocationNameLb.backgroundColor = UIColor(named: "navigationBar")
        cell.mLocationNameLb.textColor = UIColor(named: "see_map")
        let seconds = 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            self.hiddenLocationList?()
            self.didSelectLocation?(cell.mLocationNameLb.text!)
        }
    }

    @objc func seeMapPressed(sender: UIButton) {
        let seconds = 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            self.didSelectSeeMap?()
            sender.backgroundColor = .clear
        }
    }

}
