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
    func isMarkerInInactiveCordinate(restrictedZone: RestrictedZones,
                                     toCoordinate: CLLocationCoordinate2D,
                                     didResult: @escaping (Bool) -> ()) {
        let fromCoordinate = CLLocationCoordinate2D(latitude: restrictedZone.latitude, longitude: restrictedZone.longitude)
        didResult(validator.checkMarkerInInactiveCoordinate(fromCoordinate:fromCoordinate,
                                                            toCoordinate: toCoordinate,
                                                            radius: restrictedZone.radius))
    }
    
    
    //Get restricted zones
    func getRestrictedZones(completion: @escaping ([RestrictedZones]?) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getRestrictedZones)) { (result) in
            
            switch result {
            case .success(let data):
                guard let restrictedZones = BkdConverter<BaseResponseModel<[RestrictedZones]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(restrictedZones.content)

                completion(restrictedZones.content)
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    
    //Get Custom location price
    func getCustomLocation(longitude: Double, latitude: Double, completion: @escaping (CustomLocation) -> Void) {
        
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCustomLocation(longitude: longitude, latitude: latitude))) { (result) in
            
            switch result {
            case .success(let data):
                guard let customLocation = BkdConverter<BaseResponseModel<CustomLocation>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(customLocation.content)

                completion(customLocation.content!)
            case .failure(let error):
                print(error.description)
            
                break
            }
        }
    }
    
}



