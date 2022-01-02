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
  
    //MARK: -- Variables
    var myDrivers: [MainDriver]?
    lazy var myAccountsDriversViewModel = MyAccountsDriversViewModel()
    
    //MARK: -- Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    ///Get my driver list
    private func getMyDriverList () {
        MyDriversViewModel().getMyDrivers { (result, error) in
            guard let result = result else {
                return
            }
            self.myDrivers = self.myAccountsDriversViewModel.getActiveDrivers(drivers: result)
            self.mDriversTbV.reloadData()
        }
    }
    
    
    // MARK: -- Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func addDriver(_ sender: UIButton) {
        self.goToRegistrationBot(isDriverRegister: true,
                                 tableData: [RegistrationBotData.registrationDriverModel[0]])
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
            myDrivers?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
