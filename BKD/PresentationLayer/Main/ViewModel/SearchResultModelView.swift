//
//  SearchResultModelView.swift
//  BKD
//
//  Created by Karine Karapetyan on 21-06-21.
//

import UIKit



class SearchResultModelView: NSObject {    
    
        /// Get filtering cars list
        func getExteriorSizes(completion: @escaping ([Exterior]) -> Void) {
            
            SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getExteriorSize)) { (result) in
    
                switch result {
                case .success(let data):
                    guard let exteriorList = BkdConverter<BaseResponseModel<[Exterior]>>.parseJson(data: data as Any) else {
                        print("error")
                        return
                    }
                    print(exteriorList.content as Any)
                    completion(exteriorList.content!)
                case .failure(let error):
                    print(error.description)
                    break
                }
            }
        }
    
    ///Chack if car is available for rent
    func isCarAvailable(reservation: Reservation?,
                        currRentStart: Date?,
                        currRentEnd: Date?) -> Bool {
        
        guard let _ = reservation else {return true}
        for (_, value) in reservation!.innerArray {
            
            guard let _ = currRentStart, let _ = currRentEnd else {
                return true
            }
            let start = value.start
            let end = value.end
            let rentStart = Double(currRentStart!.timeIntervalSince1970)
            let rentEnd = Double(currRentEnd!.timeIntervalSince1970)
            
            if  (rentStart <= start && rentEnd >= end) ||
            (rentStart <= start && rentEnd <= end && rentEnd >= start) ||
            (rentStart >= start && rentStart <= end && rentEnd >= end) ||
            (rentStart >= start && rentEnd <= end){
                return false
            }
        }
        return true
    }
    
    
    /// Set equipment criteria for  search request
    func setEquipmentParam(index: Int, criteriaParams: [[ String : Any]]?) ->  [[ String : Any]]? {
        
        var criteriaParam: [[ String : Any]]? = criteriaParams
        let param = [ key_fieldName: (equipmentForSearch["\(index)"] ?? "") as String,
                      key_fieldValue: true,
                      key_searchOperation: SearchOperation.equals.rawValue] as [String : Any]
        criteriaParam?.append(param)
        return criteriaParam
    }
    
    
    /// Remove equipment criteria for search request
    func removeEquipmentParam(index: Int, criteriaParams: [[ String : Any]]?) ->  [[ String : Any]]? {
        
        var criteriaParam: [[ String : Any]]? = criteriaParams
        for i in 0 ..< criteriaParams!.count {
            let item:[ String : Any]  = criteriaParams![i]
            if (item[key_fieldName] as! String) == equipmentForSearch["\(index)"] {
                criteriaParam?.remove(at: i)
                break
            }
        }
        return criteriaParam
    }
    
    
    /// Set exterior criteria for  search request
    func setExteriorParam( criteriaParams: [[ String : Any]]?, exteriors: [Exterior]) -> [[ String : Any]]? {

        var criteriaParam: [[String : Any]]? = criteriaParams
        var exteriorArr:[[String: Double]] = []
        for item in exteriors {
           // let lenght = String(format: "%.2f", item.length)
//            let width = String(format: "%.2f", item.width)
//            let height = String(format: "%.2f", item.height)
            let lenght = Double(round(10 * item.length) / 10)
            let width = round(10 * item.width) / 10
            let height = Double(round(10 * item.height) / 10)


            let exterior = [key_length: lenght,
                             key_width: width,
                            key_height: height]
            exteriorArr.append(exterior)
        }
        if criteriaParams != nil {
            for i in 0 ..< criteriaParams!.count {
                let item = criteriaParams![i]
                if (item[key_fieldName] as! String) == Constant.Texts.exterior {
                    criteriaParam?.remove(at: i)
                    break
                }
            }
        }
        
        if exteriorArr.count > 0 {
            let param = [key_fieldName: Constant.Texts.exterior,
                         key_fieldValue: exteriorArr,
                          key_searchOperation: SearchOperation.In.rawValue] as [String : Any]
            
            criteriaParam?.append(param)
        }
      
        print(criteriaParam)
        return criteriaParam
    }
    
    /// Remove exterior criteria for search request
    func removeExterior(exteriors: [Exterior], exterior: Exterior) ->  [Exterior]? {
        var exteriorArr:[Exterior] = exteriors
        for i in 0 ..< exteriors.count {
            let item:Exterior = exteriorArr[i]
            if item.length == exterior.length &&
                item.width == exterior.width &&
                item.height == exterior.height {
                exteriorArr.remove(at: i)
                break
            }
        }
        return exteriorArr
    }
    
    ///Set transmissions
    func setTransmissions(criteriaParams: [[ String : Any]]?, transmissions: [ String]) -> [[ String : Any]]? {
        var criteriaParam:[[ String : Any]]? = criteriaParams
        
        for i in 0 ..< criteriaParams!.count {
            if criteriaParams![i][key_fieldName] as! String == Constant.Texts.transmission {
                criteriaParam!.remove(at: i)
                break
            }
        }
        if transmissions.count > 0 {
            let param = [key_fieldName: Constant.Texts.transmission,
                         key_fieldValue: transmissions,
                         key_searchOperation: SearchOperation.In.rawValue] as [String : Any]
            criteriaParam?.append(param)
        }
        
        return criteriaParam
    }
        
    
    /// get cars list by car type
    func getCarsByFilter(carType: CarTypes, criteria: [[ String : Any]],
                        completion: @escaping ([CarsModel]) -> Void) {
        
        var param = criteria
        print(param)
        param.insert( [ key_fieldName: Constant.Texts.type,
                        key_fieldValue: carType.id,
                        key_searchOperation: SearchOperation.equals.rawValue] as [String : Any], at: 0)
        print(param)
        SessionNetwork.init().request(with: URLBuilder.init(from: AuthAPI.getCarsByFilter(criteria: param))) { (result) in
            
            switch result {
            case .success(let data):
                guard let carList = BkdConverter<BaseResponseModel<[CarsModel]>>.parseJson(data: data as Any) else {
                    print("error")
                    return
                }
                print(carList.content as Any)
                completion(carList.content!)
            case .failure(let error):
                print(error.description)
                break
            }
        }
    }
    

    
}
