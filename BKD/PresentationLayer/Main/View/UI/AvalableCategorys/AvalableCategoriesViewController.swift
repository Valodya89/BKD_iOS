//
//  NoAvalableCategoriesViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 07-06-21.
//

import UIKit

class AvalableCategoriesViewController: UIViewController, StoryboardInitializable {

    //MARK: Outlet
   @IBOutlet weak var mAvalableCategoryTableV: UITableView!
   private var searchResultHeight: CGFloat = 0.0

   //MARK: Variables
   var searchResultV: SearchResultView?
   
   //MARK: Life Cycles
   override func viewDidLoad() {
       super.viewDidLoad()
       setUpView()
   }
   
   override func viewWillLayoutSubviews() {
       super.viewWillLayoutSubviews()
   }
   
   func setUpView() {
    configureTableView()
//        addHeaderView()
//        animateSearchResult()
   }
    private func configureTableView () {
     mAvalableCategoryTableV.register(CategoryTableViewCell.nib(),
                                          forCellReuseIdentifier: CategoryTableViewCell.identifier)
     mAvalableCategoryTableV.separatorStyle = .none
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
       self.mAvalableCategoryTableV.contentInset = .init(top: top + 20, left: 0, bottom: 0, right: 0)
       self.mAvalableCategoryTableV.setContentOffset(.init(x: 0, y: -top - 20), animated: false)
   }
   
   
}


//MARK: UITableViewDataSource
//MARK: ------------------------
extension AvalableCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
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
       return self.view.frame.size.height * 0.222772;
   }
   
   //MARK: UITableViewDelegate
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
   }
  

}
