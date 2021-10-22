//
//  CategoryViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit

class CategoryViewController: UIViewController {
   
     //MARK: Outlet
    @IBOutlet weak var mCategoryTableV: UITableView!
    private var searchResultHeight: CGFloat = 0.0

    //MARK: Variables
    let categoryViewModel: CategoryViewModel = CategoryViewModel()
    var searchResultV: SearchResultView?
    var carTypes:[CarTypes]?
    var carsList:[String : [CarsModel]?]?

    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        carTypes = ApplicationSettings.shared.carTypes
        guard let _ = carTypes else { return }
        getCarsByType()
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    func setUpView() {
        navigationController?.setNavigationBarBackground(color: color_navigationBar!)
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
    
    private func animateSearchResult(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [self] in
                self.searchResultV!.frame = CGRect(x: 0, y: top_searchResult, width: self.searchResultV!.bounds.width, height: searchResultHeight)
                self.setCollationViewPosittion(top: searchResultHeight + top_searchResult)
            }, completion: nil)
        }
    }
    
    //MARK: ACTIONS
    //MARK: ------------------------
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func chat(_ sender: UIBarButtonItem) {
        let onlineChat = UIStoryboard(name: Constant.Storyboards.chat, bundle: nil).instantiateViewController(withIdentifier: Constant.Identifiers.onlineChat) as! OnlineChatViewController
        self.navigationController?.pushViewController(onlineChat, animated: true) 
    }
}


//MARK: UITableViewDataSource
//MARK: ------------------------
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carTypes?.count ?? 0
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
       guard let _ = carsList else { return cell }
        cell.setCellInfo(carsList: carsList, carType: carTypes![indexPath.row])
        cell.mCategoryCollectionV.reloadData()
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

