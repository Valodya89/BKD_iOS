//
//  MyAccountsDriversViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 26-12-21.
//

import UIKit

class MyAccountsDriversViewController: BaseViewController {

    //MARK: -- Outlets
    @IBOutlet weak var mAddDriverContentV: UIView!
    @IBOutlet weak var mDriversTbV: UITableView!
    @IBOutlet weak var mAddDriverBtn: UIButton!
    @IBOutlet weak var mRightBarBtn: UIBarButtonItem!
    
    lazy var myDriversVM = MyDriversViewModel()
    var driver: MainDriver?

    //MARK: -- Variables
    var myDrivers: [MainDriver]?
    lazy var myAccountsDriversVM = MyAccountsDriversViewModel()
    
    //MARK: -- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
       setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyDriverList()
    }
    
    ///Set up view
    func setupView() {
       configureUI()
    }
    
    
    ///Configure UI
    func configureUI() {
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font_selected_filter!, NSAttributedString.Key.foregroundColor: UIColor.white]
        mRightBarBtn.image = img_bkd
        mAddDriverBtn.layer.cornerRadius =  mAddDriverBtn.frame.height/2
        mAddDriverContentV.layer.cornerRadius = mAddDriverContentV.frame.height/2
        mDriversTbV.register(MyDriverTableViewCell.nib(), forCellReuseIdentifier: MyDriverTableViewCell.identifier)
        mDriversTbV.delegate = self
        mDriversTbV.dataSource = self
    }


    ///Get my driver list
    private func getMyDriverList () {
        myDriversVM.getMyDrivers { (result, error) in
            guard let result = result else {return}
            self.myDrivers = self.myAccountsDriversVM.getActiveDrivers(drivers: result)
            self.mDriversTbV.reloadData()
            self.myDriversVM.getDriverToContinueToFill(allDrivers: result) { driver in
                guard let driver = driver else {return}
                self.driver = driver
            }
        }
    }

    ///Delete driver
    private func deleteDriver(id: String, indexPath: IndexPath) {
        myAccountsDriversVM.deleteDriver(id: id) { status in
            switch status {
            case .success:
                self.myDrivers?.remove(at: indexPath.row)
                self.mDriversTbV.deleteRows(at: [indexPath], with: .fade)
            default: break
            }
        }
    }
    
    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func addDriver(_ sender: UIButton) {
        if driver != nil {
            self.goToRegistrationBot(tableData: [RegistrationBotData.registrationBotModel[0]],
                                     mainDriver: self.driver)
        } else {
            self.goToRegistrationBot( tableData: [RegistrationBotData.registrationDriverModel[0]],
                                     mainDriver: nil)
        }
    }
    
    
    //Go to registeration bot screen
    func goToRegistrationBot(tableData: [RegistrationBotModel],
                             mainDriver: MainDriver?) {
        
        let registrationBotVC = RegistartionBotViewController.initFromStoryboard(name: Constant.Storyboards.registrationBot)
        registrationBotVC.tableData = tableData
        registrationBotVC.isDriverRegister = true
        registrationBotVC.mainDriver = mainDriver
        registrationBotVC.isMyAccountDriver = true
        self.navigationController?.pushViewController(registrationBotVC, animated: true)
    }
}



//MARK: -- UITableViewDelegate, UITableViewDataSource

extension MyAccountsDriversViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDrivers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCell(withIdentifier: MyDriverTableViewCell.identifier, for: indexPath) as! MyDriverTableViewCell
        cell.setCellInfo(item: myDrivers![indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDriver(id: myDrivers![indexPath.row].id, indexPath: indexPath)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToMyPersonalInfo(mainDriver: myDrivers![indexPath.row])
    }
}
