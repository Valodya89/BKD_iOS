//
//  MoreViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 14-06-21.
//

import UIKit

class MoreViewController: BaseViewController {
    //MARK: --Outlets
    @IBOutlet weak var mMoreTbV: UITableView!
    @IBOutlet weak var mBackBarBtn: UIBarButtonItem!
    @IBOutlet weak var mBkdBarBtn: UIBarButtonItem!
    
    //MARK: -- Variables
    public var vehicleModel: VehicleModel?
    public var carModel: CarsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView()  {
        mBkdBarBtn.image = img_bkd
        configureTableView()
        configureDelegates()
    }
    
    private func configureTableView() {
        // Register cells
        mMoreTbV.register(RentalConditionsTableViewCell.nib(), forCellReuseIdentifier: RentalConditionsTableViewCell.identifier)
        mMoreTbV.register(BkdAdvantagesTableViewCell.nib(), forCellReuseIdentifier: BkdAdvantagesTableViewCell.identifier)
        mMoreTbV.separatorStyle = .none
        
    }
    private func configureDelegates() {
        mMoreTbV.delegate = self
        mMoreTbV.dataSource = self
    }
    
    
    
//MARK: ACTIONS
//MARK: ---------------------
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource
//MARK: ---------------------
extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? RentalConditionsData.rentalConditionsModel.count : BkdAdvantagesData.bkdAdvantagesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RentalConditionsTableViewCell.identifier, for: indexPath) as! RentalConditionsTableViewCell
            let model = RentalConditionsData.rentalConditionsModel[indexPath.row]
            
            if vehicleModel != nil {
                cell.setCellInfo(item:model, vehicleModel: vehicleModel, index: indexPath.row)
                
            } else if carModel != nil {
                cell.setCarsCellInfo(item:model, carModel: carModel, index: indexPath.row)
            }
                
            
            return cell
            
        } else { // BKD Advantages cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BkdAdvantagesTableViewCell.identifier, for: indexPath) as! BkdAdvantagesTableViewCell
            let model = BkdAdvantagesData.bkdAdvantagesModel[indexPath.row]
            cell.setCellInfo(item: model)
                return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLb = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        titleLb.textColor = color_email!
        titleLb.font = font_more_header
        titleLb.text = section == 0 ? Constant.Texts.rentalConditions : Constant.Texts.bkdAdvantages
        titleLb.setPadding(16)
        return titleLb
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 || indexPath.row == 4 {
                return 55
            }
            return 30
        }
        return  tableView.estimatedRowHeight
    }
    
    
}
