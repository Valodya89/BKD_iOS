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
    var parkingList:[Parking] = []

    var didSelectSeeMap: ((Parking) -> Void)?
    var didSelectLocation: ((String) -> Void)?
    var hiddenLocationList: (() -> Void)?


    override func awakeFromNib() {
        superview?.awakeFromNib()
        self.setUpView()
        getParkingList()
    }
    
    func setUpView() {
        // TableView
        mPickUpLocationTableView.separatorStyle = .none
        mPickUpLocationTableView.dataSource = self
        mPickUpLocationTableView.delegate = self
        mPickUpLocationTableView.register(DropDownTableViewCell.nib(),
                                          forCellReuseIdentifier: DropDownTableViewCell.identifier)
       

    }
    
    private func getParkingList() {
        MainViewModel().getParking { [weak self] (result) in
            guard let self = self else {return}
            self.parkingList = result ?? []
            self.mPickUpLocationTableView.reloadData()
            
        }
    }
        
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTableViewCell.identifier) as! DropDownTableViewCell
        
        cell.setCellInfo(item: parkingList[indexPath.row], index: indexPath.row)
        cell.mSeeMapBtn.addTarget(self, action: #selector(seeMapPressed(sender:)), for: .touchUpInside)
        
        //Enabled imageView
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(seeMapPressed))
        cell.mMapImgV.addGestureRecognizer(tapImg)
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! DropDownTableViewCell
        cell.mLocationNameLb.backgroundColor = color_navigationBar
        cell.mLocationNameLb.textColor = color_menu
        let seconds = 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            self.hiddenLocationList?()
            self.didSelectLocation?(cell.mLocationNameLb.text!)
        }
    }

    @objc func seeMapPressed(sender: UIButton) {
        let seconds = 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            self.didSelectSeeMap?(parkingList[sender.tag])
            sender.backgroundColor = .clear
        }
    }

}
