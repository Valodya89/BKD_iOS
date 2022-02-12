//
//  PaymentStatusUITableView.swift
//  PaymentStatusUITableView
//
//  Created by Karine Karapetyan on 14-09-21.
//

import UIKit

class PaymentStatusUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var didPressPayment:((Bool)->Void)?
    var statusArr:[PaymentStatusModel]? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.register(PaymentStatusUITableViewCell.nib(), forCellReuseIdentifier: PaymentStatusUITableViewCell.identifier)
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    

    //MARK: -- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  statusArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentStatusUITableViewCell.identifier, for: indexPath) as! PaymentStatusUITableViewCell
        cell.setCellInfo(item: statusArr![indexPath.row])
        cell.didPressPay = { isPayLater in
            self.didPressPayment?(isPayLater)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = statusArr![indexPath.row]
        if !item.isActivePaymentBtn && !item.waitingForDistanc {
            return  CGFloat(height75)
        }
        return height115
    }

}
