//
//  CategoryViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-05-21.
//

import UIKit

class CategoryViewController: UIViewController {
   
        
    @IBOutlet weak var mCategoryTableV: UITableView!
    private var searchResultHeight: CGFloat = 0.0

    var searchResultV: SearchResultView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        //CollectionView
        mCategoryTableV.register(CategoryTableViewCell.nib(),
                                          forCellReuseIdentifier: CategoryTableViewCell.identifier)
        mCategoryTableV.separatorStyle = .none
        
        
        
   // addHeaderView()
     //   animateSearchResult()
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
    private func setCollationViewPosittion(top: CGFloat) {
        self.mCategoryTableV.contentInset = .init(top: top + 20, left: 0, bottom: 0, right: 0)
        self.mCategoryTableV.setContentOffset(.init(x: 0, y: -top - 20), animated: false)
    }
    //MARK: ACTIONS
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryData.categoryModel.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell

        let categoryModel: CategoryModel = CategoryData.categoryModel[indexPath.row]
        cell.mCategoryNameLb.text = categoryModel.categoryName
        cell.collectionData = CategoryData.categoryModel[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.222772;//Choose your custom row height
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
//0.222772
   

}

