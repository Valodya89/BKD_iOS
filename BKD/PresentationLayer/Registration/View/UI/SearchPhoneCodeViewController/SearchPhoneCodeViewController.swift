//
//  SearchPhoneCodeViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 06-07-21.
//

import UIKit

class SearchPhoneCodeViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var mSearchBtn: UIButton!
    @IBOutlet weak var mSearchTableV: UITableView!
    @IBOutlet weak var mSearchTxtFl: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func searc(_ sender: UIButton) {
    }
    

}

extension SearchPhoneCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchPhoneCodeTableViewCell.identifier, for: indexPath) as!  SearchPhoneCodeTableViewCell
        return cell
    }
    
    
}
