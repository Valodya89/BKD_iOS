//
//  AccidentFormTableView.swift
//  AccidentFormTableView
//
//  Created by Karine Karapetyan on 27-09-21.
//

import UIKit


protocol AccidentFormTableViewDelegate: AnyObject {
    func pressedTakePhoto(index: Int)
    func pressedAddMore(index: Int)
}

class AccidentFormTableView: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: -- Variables
    var accidentFormArr:[AccidentFormModel] = [AccidentFormModel(accidentFormImg: nil, isTakePhoto: true)]
    weak var accidentFormDelegate: AccidentFormTableViewDelegate?
    
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.delegate = self
        self.dataSource = self
        self.register(AccidentFormTableCell.nib(), forCellReuseIdentifier: AccidentFormTableCell.identifier)
    }

    
    
    //MARK: UITableViewDataSource
    //MARK: ----------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  accidentFormArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccidentFormTableCell.identifier, for: indexPath) as! AccidentFormTableCell
        cell.setCallInfo(itemList: accidentFormArr, index: indexPath.row)
        
        cell.didPressTakePhoto = { index in
            self.accidentFormDelegate?.pressedTakePhoto(index: index)
        }
        cell.didPressAddMore = { index in
            self.accidentFormDelegate?.pressedAddMore(index: index)
        }
        return cell
    }
}

    
 
