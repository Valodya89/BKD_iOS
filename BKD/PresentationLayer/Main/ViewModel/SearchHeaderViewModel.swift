//
//  SearchHeaderViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-05-21.
//

import UIKit

class SearchHeaderViewModel: NSObject {
    static let shared = MainViewModel()
    var searchDateModel = SearchDateModel()

    let validator = Validator()
    
    override init() {}
    
    //MARK: VALIDATIONS
    //MARK: -----------------------
    func  isFieldsFilled(pickUpDay: String?,
                         returnDay: String?,
                         pickUpTime: String?,
                         returnTime: String?,
                         pickUpLocation: String?,
                         returnLocation: String?,
                         didResult: @escaping ([ValidationType]) -> ()) {
       let searchDateModel = SearchDateModel (pickUpDay: pickUpDay,
                                           returnDay: returnDay,
                                           pickUpTime: pickUpTime,
                                           returnTime: returnTime,
                                           pickUpLocation: pickUpLocation,
                                           returnLocation: returnLocation)
        didResult(validator.checkSearchDatas(searchDateModel: searchDateModel))
    }
    

}
