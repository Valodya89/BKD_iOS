//
//  SearchResultModelView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit

class SearchResultModelView: NSObject {
    var searchResultModelView = SearchResultModelView()
    
    func getSearchEditResult(pickupLocation: String,
                             returnLocation: String,
                             pickupDay: String,
                             returnDay: String,
                             pickupDate: String,
                             returnDate:String) -> SearchEditModel {
        let searchEdit: SearchEditModel = SearchEditModel(pickUpLocationName: pickupLocation,
                                                         pickUpDay: pickupDay,
                                                         pickUpWeakAndMonth: pickupDate,
                                                         returnLocationName: returnLocation,
                                                         returnDay: returnDay,
                                                         returnWeakAndMonth: returnDate)
        
        return searchEdit
        
    }

}
