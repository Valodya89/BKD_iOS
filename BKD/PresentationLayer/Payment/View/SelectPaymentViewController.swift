//
//  SelectPaymentViewController.swift
//  BKD
//
//  Created by Karine Karapetyan on 20-07-21.
//

import UIKit

class SelectPaymentViewController: UIViewController, StoryboardInitializable {
    
    let paymentTypes = PaymentTypeData.paymentTypeModel

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymenTypeTableViewCell.identifier, for: indexPath) as! PaymenTypeTableViewCell
//          cell.setCellInfo(item: model)
//          cell.delegate = self
          return cell
    }
    
    
}
