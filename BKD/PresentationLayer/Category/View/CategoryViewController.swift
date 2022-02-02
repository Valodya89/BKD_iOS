//
//  CategoryViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit
import SideMenu


class CategoryViewController: BaseViewController {
   
     //MARK: Outlet
    @IBOutlet weak var mCategoryTableV: UITableView!
    private var searchResultHeight: CGFloat = 0.0

    //MARK: Variables
    var menu: SideMenuNavigationController?

    let categoryViewModel: CategoryViewModel = CategoryViewModel()
    var searchResultV: SearchResultView?
    var carTypes:[CarTypes]?
    var carsList:[String : [CarsModel]?]?

    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        carTypes = ApplicationSettings.shared.carTypes
        // menu
        menu = SideMenuNavigationController(rootViewController: LeftViewController())
        self.setmenu(menu: menu)
        guard let _ = carTypes else { return }
        getCarsByType()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setUpView() {
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryViewController.handleMenuToggle), name: Constant.Notifications.dismissMenu, object: nil)
        navigationController?.setNavigationBarBackground(color: color_dark_register!)
        //CollectionView
        mCategoryTableV.register(CategoryTableViewCell.nib(),
                                          forCellReuseIdentifier: CategoryTableViewCell.identifier)
        mCategoryTableV.separatorStyle = .none

    }
    
    private func setCollationViewPosittion(top: CGFloat) {
        self.mCategoryTableV.contentInset = .init(top: top + 20, left: 0, bottom: 0, right: 0)
        self.mCategoryTableV.setContentOffset(.init(x: 0, y: -top - 20), animated: false)
    }
    
    /// Get all cars by type
    private func getCarsByType() {
        guard let carsList = ApplicationSettings.shared.carsList else {
            categoryViewModel.getCarsByTypes(carTypes:  carTypes!) { [self] (cars) in
                guard let _ = cars else {return}
                ApplicationSettings.shared.carsList = cars!
                self.carsList = cars!
                self.mCategoryTableV.reloadData()
            }
            return
        }
        self.carsList = carsList
    }
    
    private func addHeaderView() {
        //add top views
        searchResultV = SearchResultView()
        searchResultHeight = view.frame.height * 0.123762
        searchResultV!.frame = CGRect(x: 0, y: -200, width: self.view.bounds.width, height: searchResultHeight)
        searchResultV?.mNoticeLb.isHidden = false
        searchResultV?.mFilterV.isHidden = true
        self.view.addSubview(searchResultV!)
        self.setCollationViewPosittion(top: searchResultHeight + top_searchResult)

    }
    
    ///Animate
    private func animateSearchResult(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                self.searchResultV!.frame = CGRect(x: 0, y: top_searchResult, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                self.setCollationViewPosittion(top: searchResultHeight + top_searchResult)
            }, completion: nil)
        }
    }
    
    ///will open detail controller
    private func goToDetailPage(carModel: CarsModel,
                                carType: String) {
        
        let detailsVC = DetailsViewController.initFromStoryboard(name: Constant.Storyboards.details)
        detailsVC.vehicleModel = CategoryViewModel().getVehicleModel(car: carModel, carType: carType)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    //MARK: -- ACTIONS
   
    @IBAction func menu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func chat(_ sender: UIBarButtonItem) {
        let onlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.onlineChat) as! OnlineChatViewController
        self.navigationController?.pushViewController(onlineChat, animated: true) 
    }
    
    ///Dismiss left menu and open chant screen
    @objc private func handleMenuToggle(notification: Notification) {
        menu?.dismiss(animated: true, completion: nil)
        openChatPage(viewCont: self)
    }
}


//MARK: -- UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carTypes?.count ?? 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
       guard let _ = carsList else { return cell }
        cell.setCellInfo(carsList: carsList, carType: carTypes![indexPath.row])
        cell.mCategoryCollectionV.reloadData()
        cell.openCarDetail = {car, carType in
            self.goToDetailPage(carModel: car, carType: carType)
         }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = carsList else { return 0}
        let item:[CarsModel] = carsList![carTypes![indexPath.row].id]! ?? []
        if item.count == 0 {
            return 0
        }
        return self.view.frame.size.height * 0.222772
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
   

}

