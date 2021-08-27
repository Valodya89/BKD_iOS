//
//  GooglePlacesManager.swift
//  BKD
//
//  Created by Karine Karapetyan on 25-08-21.
//

import Foundation
import GooglePlaces

struct Place {
    let name: String
    let identifier: String
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
    }
    
    public func findPlace(query: String, complition: @escaping (Result <[Place], Error>) -> Void ) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil) { (results, error) in
            guard let results = results, error == nil else {
                complition(.failure(PlacesError.failedToFind))
                return
            }
            
            let places:[Place] = results.compactMap { Place.init(name: $0.attributedFullText.string, identifier: $0.placeID)
            }
            complition(.success(places))
            
        }
    }
}
