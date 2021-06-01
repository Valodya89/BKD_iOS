//
//  CustomLocationViewModel.swift
//  BKD
//
//  Created by Karine Karapetyan on 31-05-21.
//

import UIKit
import CoreLocation

class CustomLocationViewModel: NSObject {
    
    static let shered = CustomLocationViewModel()
    
    let validator = Validator()


    //MARK: VALIDATION
    func isMarkerInInactiveCordinate(fromCoordinate: CLLocationCoordinate2D,
                                     toCoordinate: CLLocationCoordinate2D,
                                     radius: Double,
                                     didResult: @escaping (Bool) -> ()) {
        
        didResult(validator.checkMarkerInInactiveCoordinate(fromCoordinate:fromCoordinate,
                                                            toCoordinate: toCoordinate,
                                                            radius: radius))
    }
    
}
