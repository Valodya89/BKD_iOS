//
//  SearchCustomLocationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 31-05-21.
//

import UIKit

class SearchCustomLocationViewModel: NSObject {
   // static let shared = SearchCustomLocationViewModel()
    
    func getGooglePlaces(place: String, didResult: @escaping (Any?) -> () /*@escaping (State<SearchPlacesResult>) -> ()*/) {
        NetworkManager.searchGooglePlase(place: place) { (response, success) in
            
            guard let response = response else {
               // didResult(State.error(message: "Something went wrong"))
                return
            }
            if success == true {
                //didResult(State.success(data: (result?.data)))
                didResult(response)
            } else {
                didResult(response)

            }
            
    }
        }

    

    
}
